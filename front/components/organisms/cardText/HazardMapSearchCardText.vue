<template>
  <v-card tile outlined class="mt-5 pa-2">
    <v-row justify="center">
      <v-col v-for="item in hazardMapItems" :key="item.id" :cols="item.col">
        <v-card-text>
          <a v-if="item.to !== null" :href="item.to" class="text-decoration-none">{{ item.title }}</a>
          <span v-else>{{ item.title }}</span>
        </v-card-text>
        <v-divider />
      </v-col>
      <v-col>
        <v-card-text>
          ※災害が想定されていないなどの理由で、自治体がハザードマップを公開していない場合は黒字で表示しています。<br>
          ※ハザードマップに関する情報は全国で随時更新されています。最新の情報は、自治体の公式サイトなどでご確認ください。
        </v-card-text>
      </v-col>
    </v-row>
    <HazardMapConfirmBtn v-if="$auth.loggedIn" class="text-center" />
  </v-card>
</template>

<script>
import HazardMapConfirmBtn from '~/components/organisms/btns/HazardMapConfirmBtn.vue'

export default {
  name: 'HazardMapSearchCardText',

  components: {
    HazardMapConfirmBtn
  },

  props: {
    hazardMap: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      hazardMapItems: [
        { id: 1, title: '津波', to: this.hazardMap.tsunami, col: 6 },
        { id: 2, title: '洪水', to: this.hazardMap.flood, col: 6 },
        { id: 3, title: '土砂災害', to: this.hazardMap.landslide, col: 6 },
        { id: 4, title: '内水氾濫', to: this.hazardMap.inland_flood, col: 6 },
        { id: 5, title: '高潮', to: this.hazardMap.storm_surge, col: 6 },
        { id: 6, title: '火山', to: this.hazardMap.volcano, col: 6 },
        { id: 7, title: 'ため池', to: this.hazardMap.reservoir, col: 12 }
      ]
    }
  }
}
</script>
