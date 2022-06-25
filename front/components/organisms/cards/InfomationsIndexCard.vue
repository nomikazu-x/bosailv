<template>
  <BaseTitleCard title="通知一覧">
    <Processing v-if="processing" />
    <article v-if="infomations != null && infomations.length === 0">
      <span class="ml-1">お知らせはありません。</span>
    </article>
    <InfomationList
      v-for="infomation in infomations"
      :key="infomation.id"
      :infomation="infomation"
    />

    <Pagination
      class="mt-5"
      :info="info"
      @pagination="onPagination"
    />
  </BaseTitleCard>
</template>

<script>
export default {
  props: {
    info: {
      type: Object,
      default: null
    },
    infomations: {
      type: Array,
      default: () => []
    },
    processing: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    alert: {
      type: String,
      default: null
    },
    notice: {
      type: String,
      default: null
    }
  },
  methods: {
    onPagination (value) {
      return this.$emit('pagination', value)
    }
  }
}
</script>
