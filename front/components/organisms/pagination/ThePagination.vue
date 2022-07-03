<template>
  <div v-if="info != null && info.total_pages > 1">
    <v-pagination
      id="pagination"
      v-model="page"
      color="#ef5350"
      :length="info.total_pages"
      :total-visible="7"
      @input="onPagination"
    />
  </div>
</template>

<script>
export default {
  props: {
    info: {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      page: 1
    }
  },
  methods: {
    onPagination () {
      return this.$emit('pagination', this.page)
    }
  }
}
</script>
