<template>
  <v-card>
    <Processing v-if="processing" />
    <v-card-title>通知一覧</v-card-title>
    <v-card-text>
      <v-row v-if="info != null && info.total_count > info.limit_value">
        <v-col cols="auto" md="5" align-self="center">
          {{ info.total_count.toLocaleString() }}件中 {{ $pageFirstNumber(info).toLocaleString() }}-{{ $pageLastNumber(info).toLocaleString() }}件を表示
        </v-col>
        <v-col cols="auto" md="7" class="d-flex justify-end">
          <v-pagination id="pagination" v-model="page" :length="info.total_pages" @input="onPagination()" />
        </v-col>
      </v-row>

      <article v-if="lists != null && lists.length === 0">
        <span class="ml-1">お知らせはありません。</span>
        <v-divider class="my-4" />
      </article>
      <InfomationList
        v-for="list in lists"
        :key="list.id"
        :list="list"
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
    lists: {
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
