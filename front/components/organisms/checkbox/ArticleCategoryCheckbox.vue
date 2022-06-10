<template>
  <div>
    <v-card-text>カテゴリー選択</v-card-text>
    <ValidationProvider v-slot="{ errors }" name="category" rules="required">
      <v-row>
        <v-col v-for="category in categories" :key="category.id" cols="4" sm="3" md="3" style="height: 50px;">
          <v-checkbox
            v-model="valueModel"
            :value="category.value"
            :label="category.name"
            color="green darken-1"
            :error-messages="errors"
          />
        </v-col>
      </v-row>
    </ValidationProvider>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: Array,
      default: () => []
    }
  },
  data () {
    return {
      categories: [
        { name: '電気・ガス', value: 'gas' },
        { name: '水道', value: 'watersuppry' },
        { name: '応急', value: 'emergency' },
        { name: '災害時の知恵', value: 'knowledge' },
        { name: '地震', value: 'earthquake' },
        { name: '津波', value: 'tsunami' },
        { name: '火山噴火', value: 'volcano' },
        { name: '大雪', value: 'snow' },
        { name: '台風', value: 'typhoon' },
        { name: '内水氾濫', value: 'internalwater' },
        { name: '河川洪水', value: 'riverflood' },
        { name: '土砂災害', value: 'landslide' },
        { name: '強風', value: 'strongwind' },
        { name: '熱中症', value: 'heatstroke' },
        { name: '防災情報', value: 'warning' },
        { name: '国民保護情報', value: 'jalert' }
      ]
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
