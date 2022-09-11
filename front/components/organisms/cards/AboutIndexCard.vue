<template>
  <v-row>
    <v-col style="background-color: #fff;">
      <div class="text-center mb-5">
        <v-img class="mx-auto mt-10 px-4" :src="image.LOGO_IMAGE" max-width="700" />

        <v-card-subtitle>
          最近災害がふえているけど何からしたらいいんだろ...。
          <br>
          「防災タスク」をこなして、あなたの防災レベルをあげよう！
        </v-card-subtitle>

        <OrangeBtn to="/signup" class="my-2" large>
          さっそくはじめる
          <v-icon>mdi-chevron-right</v-icon>
        </OrangeBtn>
      </div>

      <div class="pa-5" style="background-color: #DFEEE5;">
        <v-card class="mt-10 pa-1">
          <v-row>
            <v-col cols="12" sm="6" order-sm="1">
              <v-card-title class="my-5 justify-center" style="color: #117768;">ハザードマップを確認しよう</v-card-title>
              <v-card-text>出身市町村を設定すると、市町村で検索できるようになってる</v-card-text>
            </v-col>
            <v-col cols="12" sm="6" order-sm="2">
              <v-img :src="image.HAZARD_MAP_IMAGE" />
            </v-col>
          </v-row>
        </v-card>

        <v-card class="mt-10 pa-1">
          <v-row>
            <v-col cols="12" sm="6" order-sm="2">
              <v-card-title class="my-5 justify-center" style="color: #117768;">避難所を確認しよう</v-card-title>
              <v-card-text>出身市町村を設定すると、市町村で検索できるようになってる</v-card-text>
            </v-col>
            <v-col cols="12" sm="6" order-sm="1">
              <v-img :src="image.SHELTER_IMAGE" />
            </v-col>
          </v-row>
        </v-card>

        <v-card class="mt-10 pa-1">
          <v-row>
            <v-col cols="12" sm="6" order-sm="1">
              <v-card-title class="my-5 justify-center" style="color: #117768;">防災SNSをフォローしよう</v-card-title>
              <v-card-text>いざというときの情報収集に役立つSNS。災害時に役立つ情報を発信しているSNSをフォローしておこう。</v-card-text>
            </v-col>
            <v-col cols="12" sm="6" order-sm="2">
              <v-img :src="image.SNS_TASK_IMAGE" />
            </v-col>
          </v-row>
        </v-card>

        <v-card class="mt-10 pa-1">
          <v-row>
            <v-col cols="12" sm="6" order-sm="2">
              <v-card-title class="my-5 justify-center" style="color: #117768;">おうち防災に取り組もう</v-card-title>
              <v-card-text>テキスト</v-card-text>
            </v-col>
            <v-col cols="12" sm="6" order-sm="1">
              <v-img :src="image.HOUSE_TASK_IMAGE" />
            </v-col>
          </v-row>
        </v-card>

        <v-card class="mt-10 pa-1">
          <v-row>
            <v-col cols="12" sm="6" order-sm="1">
              <v-card-title class="my-5 justify-center" style="color: #117768;">家族会議しよう</v-card-title>
              <v-card-text>いざというときの行動を家族で確認して、各項目をメモしておこう。</v-card-text>
            </v-col>
            <v-col cols="12" sm="6" order-sm="2">
              <v-img :src="image.FAMILY_RULE_IMAGE" />
            </v-col>
          </v-row>
        </v-card>

        <v-card class="mt-10 pa-1">
          <v-row>
            <v-col cols="12" sm="6" order-sm="2">
              <v-card-title class="my-5 justify-center" style="color: #117768;">緊急時連絡先を登録しよう</v-card-title>
              <v-card-text>緊急時連絡先を登録して、緊急時連絡先にすぐに連絡できるようにしよう。</v-card-text>
            </v-col>
            <v-col cols="12" sm="6" order-sm="1">
              <v-img :src="image.EMERGENCY_CONTACT_IMAGE" />
            </v-col>
          </v-row>
        </v-card>

        <v-card class="mt-10 pa-1">
          <v-row>
            <v-col cols="12" sm="6" order-sm="1">
              <v-card-title class="my-5 justify-center" style="color: #117768;">備蓄品を確認しよう</v-card-title>
              <v-card-text>家族情報を登録すると、必要な備蓄品と数量を計算して一覧で確認できる。</v-card-text>
            </v-col>
            <v-col cols="12" sm="6" order-sm="2">
              <v-img :src="image.STOCK_IMAGE" />
            </v-col>
          </v-row>
        </v-card>

        <v-card class="mt-10 pa-1">
          <v-row>
            <v-col cols="12" sm="6" order-sm="2">
              <v-card-title class="my-5 justify-center" style="color: #117768;">災害時役立つ記事を活用しよう</v-card-title>
              <v-card-text>災害時役立つ知識をジャンルごとにアウトプットしておこう。また、他の人の書いた記事もいいねすることでマイ記事に登録できる。</v-card-text>
            </v-col>
            <v-col cols="12" sm="6" order-sm="1">
              <v-img :src="image.GENRE_IMAGE" />
            </v-col>
          </v-row>
        </v-card>
        <div class="text-center my-5">
          <OrangeBtn to="/signup" class="my-2" large>
            さっそくはじめる
            <v-icon>mdi-chevron-right</v-icon>
          </OrangeBtn>
        </div>
      </div>
    </v-col>
  </v-row>
</template>

<script>
import Application from '~/plugins/application.js'
import OrangeBtn from '~/components/atoms/btns/OrangeBtn.vue'
import LOGO_IMAGE from '~/assets/images/logo.jpg'
import HAZARD_MAP_IMAGE from '~/assets/images/hazard_map_image.png'
import SHELTER_IMAGE from '~/assets/images/shelter_image.png'
import SNS_TASK_IMAGE from '~/assets/images/sns_task_image.png'
import HOUSE_TASK_IMAGE from '~/assets/images/house_task_image.png'
import FAMILY_RULE_IMAGE from '~/assets/images/family_rule_image.png'
import EMERGENCY_CONTACT_IMAGE from '~/assets/images/emergency_contact_image.png'
import STOCK_IMAGE from '~/assets/images/stock_image.png'
import GENRE_IMAGE from '~/assets/images/genre_image.png'
import NO_IMAGE from '~/assets/images/xxlarge_noimage.jpeg'

export default {
  name: 'AboutIndexCard',

  components: {
    OrangeBtn
  },

  mixins: [Application],

  computed: {
    image () {
      return {
        LOGO_IMAGE,
        HAZARD_MAP_IMAGE,
        SHELTER_IMAGE,
        SNS_TASK_IMAGE,
        HOUSE_TASK_IMAGE,
        FAMILY_RULE_IMAGE,
        EMERGENCY_CONTACT_IMAGE,
        STOCK_IMAGE,
        GENRE_IMAGE,
        NO_IMAGE
      }
    }
  },

  created () {
    this.loading = false
  }
}
</script>
