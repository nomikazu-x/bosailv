<template>
  <OneColumnContainer>
    <Loading v-if="loading" />
    <Message v-if="!loading" :alert="alert" :notice="notice" />

    <v-row v-if="!loading" justify="center">
      <v-col cols="12" sm="10" md="10">
        <InfomationsIndexCard
          :info="info"
          :infomations="infomations"
          :processing="processing"
          @pagination="onPagination"
        />
      </v-col>
    </v-row>
  </OneColumnContainer>
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
