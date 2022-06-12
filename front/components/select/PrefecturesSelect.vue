<template>
  <v-row>
    <v-col>
      <ValidationProvider v-slot="{ errors }" name="prefecture" rules="required">
        <v-select
          v-model="valueModel"
          label="出身都道府県"
          outlined
          :value="value"
          :error-messages="errors"
          :items="prefectures"
          item-text="name"
          item-value="id"
        />
      </ValidationProvider>
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    prefectures: {
      type: Array,
      default: () => []
    },
    value: {
      type: [Object, Number],
      default: undefined
    }
  },
  computed: {
    valueModel: {
      get () {
        return this.value
      },
      set (newVal) {
        return this.$emit('input', newVal)
      }
    }
  }
}
</script>
