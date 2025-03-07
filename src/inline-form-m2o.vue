<template>
	<v-notice v-if="!readAllowed" type="warning">
		{{ t('interfaces.inline-form-m2o.no-read-permission') }}
	</v-notice>
	<v-notice v-else-if="!relationInfo" type="warning">
		{{ t('relationship_not_setup') }}
	</v-notice>
	<div v-else class="wrapper">
		<!-- Commented out because it wasn't working when creating a new entry createAllowed seem bugged -->
		<!-- <v-notice v-if="!(createAllowed || updateAllowed)" type="warning">
			{{ t('interfaces.inline-form-m2o.no-update-permission') }}
		</v-notice> -->
		<v-form
			v-model="internalEdits"
			:disabled="disabled"
			:loading="loading"
			:show-no-visible-fields="false"
			:initial-values="initialValues"
			:primary-key="currentPrimaryKey"
			:fields="fields"
			:validation-errors="validationErrors"
		/>
	</div>
</template>

<script lang="ts" setup>
import { useApi, useStores } from '@directus/extensions-sdk';
import { computed, ref, toRefs, watch } from 'vue';
import { useI18n } from '@/composables/use-i18n';
import { get, isEmpty, isNil } from 'lodash-es';
import { useRelationM2O } from '@/composables/use-relation-m2o.js';
import { getEndpoint } from '@directus/utils';
import { unexpectedError } from '@/utils/unexpected-error.js';
import { useItemPermissions } from '@/composables/use-permissions';

interface Props {
	value?: string | number | Record<string, any> | null;
	collection: string;
	field: string;
	disabled?: boolean;
	createRelatedItem?: 'withContent' | 'always';
}

const props = withDefaults(defineProps<Props>(), {
	value: null,
	disabled: false,
	createRelatedItem: 'withContent',
});

const emit = defineEmits<{
	(e: 'input', value: Props['value']): void;
}>();

const { collection, field } = toRefs(props);
const { t } = useI18n();
const api = useApi();

const validationErrors = ref<any[]>([]);

const { relationInfo } = useRelationM2O(collection, field);
const currentPrimaryKey = computed<string | number>(() => {
	if (!props.value || !relationInfo.value) return '+';

	if (typeof props.value === 'number' || typeof props.value === 'string') {
		return props.value;
	}

	return get(props.value, relationInfo.value.relatedPrimaryKeyField.field, '+');
});
const isNew = computed(() => currentPrimaryKey.value === '+');

const { internalEdits, loading, initialValues, fetchItem } = useItem();
const {
	fields: fieldsWithPermissions,
	createAllowed,
	updateAllowed,
} = useItemPermissions(
	computed(() => relationInfo.value?.relatedCollection.collection ?? ''),
	currentPrimaryKey,
	isNew,
);

const { usePermissionsStore } = useStores();
const { hasPermission } = usePermissionsStore();
const readAllowed = computed(() => {
	if (!relationInfo.value) return false;
	return hasPermission(relationInfo.value.relatedCollection.collection, 'read');
});

// don't show circular field
const fields = computed(() =>
	!isNil(relationInfo.value?.relation.meta?.one_field)
		? fieldsWithPermissions.value.filter(({ field }) => field !== relationInfo.value?.relation.meta?.one_field)
		: fieldsWithPermissions.value,
);

watch(
	internalEdits,
	() => {
		if (!relationInfo.value) return;

		if (!isEmpty(internalEdits.value) || (isNew.value && props.createRelatedItem === 'always')) {
			const item = internalEdits.value;

			if (!isNew.value) {
				item[relationInfo.value.relatedPrimaryKeyField.field] = currentPrimaryKey.value;
			}

			emit('input', item);
		}
	},
	{ deep: true, immediate: true },
);

// watch for a discard (value will be changed back to it's initial key value)
// refetch data if this is not a new item
watch(
	() => props.value,
	() => {
		if (!relationInfo.value) return;

		if (get(initialValues.value, relationInfo.value.relatedPrimaryKeyField.field) === props.value && !isNew.value) {
			fetchItem();
		}
	},
);

function useItem() {
	const internalEdits = ref<Record<string, any>>({});
	const loading = ref(false);
	const initialValues = ref<Record<string, any> | null>(null);
	const { useNotificationsStore } = useStores();
	const notificationStore = useNotificationsStore();

	watch(
		[currentPrimaryKey, isNew, relationInfo],
		() => {
			if (!isNew.value) fetchItem();
		},
		{ immediate: true },
	);

	return { internalEdits, loading, initialValues, fetchItem };

	async function fetchItem() {
		if (!currentPrimaryKey.value || !relationInfo.value) return;

		loading.value = true;

		const baseEndpoint = getEndpoint(relationInfo.value.relatedCollection.collection);
		const endpoint = relationInfo.value.relatedCollection.collection.startsWith('directus_')
			? `${baseEndpoint}/${currentPrimaryKey.value}`
			: `${baseEndpoint}/${encodeURIComponent(currentPrimaryKey.value)}`;

		let fields = '*';

		try {
			const response = await api.get(endpoint, { params: { fields } });

			initialValues.value = response.data.data;
		} catch (err: any) {
			unexpectedError(err, notificationStore, t);
		} finally {
			loading.value = false;
			internalEdits.value = {};
		}
	}
}
</script>

<style lang="scss" scoped>
.wrapper {
	& > div + div {
		margin-top: var(--form-vertical-gap);
	}
}
</style>
