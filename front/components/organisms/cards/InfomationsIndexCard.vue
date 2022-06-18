<template>
  <v-card>
    <Processing v-if="processing" />
    <v-card-title>通知一覧</v-card-title>
    <v-card-text>
      <article v-if="infomations != null && infomations.length === 0">
        <span class="ml-1">お知らせはありません。</span>
        <v-divider class="my-4" />
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
    </v-card-text>
  </v-card>
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
