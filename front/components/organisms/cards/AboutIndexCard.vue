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
              <v-card-text>災害は突然やってきます。思い立ったときにハザードマップを確認しておきましょう。</v-card-text>
              <v-sheet outlined color="#FFD54F" class="pa-1">
                <v-card flat>
                  <v-list>
                    <v-list-item>
                      <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                      <v-list-item-content>
                        <v-list-item-title class="wrap-text">「ハザードマップを確認した！」をクリックして5ポイント獲得！</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-sheet>
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
              <v-card-text>いざというときにあわてないように、自宅や働いている場所の近くにある避難場所と安全な避難経路を、しっかり確認しておきましょう。</v-card-text>
              <v-sheet outlined color="#FFD54F" class="pa-1">
                <v-card flat>
                  <v-list>
                    <v-list-item>
                      <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                      <v-list-item-content>
                        <v-list-item-title class="wrap-text">「マイ避難所に登録する」ボタンをクリックして5ポイント獲得！</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-sheet>
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
              <v-card-text>いざというときの情報収集に役立つSNS。災害時に役立つ情報を発信しているSNSアカウントをフォローしておきましょう。</v-card-text>
              <v-sheet outlined color="#FFD54F" class="pa-1">
                <v-card flat>
                  <v-list>
                    <v-list-item>
                      <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                      <v-list-item-content>
                        <v-list-item-title class="wrap-text">各防災SNSアカウントごとの「完了！」ボタンをクリックして1ポイント獲得！</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-sheet>
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
              <v-card-text>家具をしっかりと留めたり、ガラスの飛散防止対策を施すなどのおうち防災タスクをこなして、震災時のけがから身を守りましょう。</v-card-text>
              <v-sheet outlined color="#FFD54F" class="pa-1">
                <v-card flat>
                  <v-list>
                    <v-list-item>
                      <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                      <v-list-item-content>
                        <v-list-item-title class="wrap-text">各おうち防災タスクごとの「完了！」ボタンをクリックして1ポイント獲得！</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-sheet>
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
              <v-card-text>
                家庭によって生活スタイルはさまざまです。そこで、普段の生活を考えながら、災害時に困ることを家族で話し合えば、「必要なこと」が見えてきます。<br>
                いざというときに備えて、家族会議をして各項目をメモしておきましょう。
              </v-card-text>
              <v-sheet outlined color="#FFD54F" class="pa-1">
                <v-card flat>
                  <v-list>
                    <v-list-item>
                      <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                      <v-list-item-content>
                        <v-list-item-title class="wrap-text">家族会議の項目をメモし、「作成」をクリックして5ポイント獲得！</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-sheet>
            </v-col>
            <v-col cols="12" sm="6" order-sm="2">
              <v-img :src="image.FAMILY_RULE_IMAGE" />
            </v-col>
          </v-row>
        </v-card>

        <v-card class="mt-10 pa-1">
          <v-row>
            <v-col cols="12" sm="6" order-sm="2">
              <v-card-title class="my-5 justify-center" style="color: #117768;">緊急連絡先を登録しよう</v-card-title>
              <v-card-text>緊急連絡先を登録して、災害時すぐに連絡できるようにしておきましょう。</v-card-text>
              <v-sheet outlined color="#FFD54F" class="pa-1">
                <v-card flat>
                  <v-list>
                    <v-list-item>
                      <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                      <v-list-item-content>
                        <v-list-item-title class="wrap-text">緊急時連絡先を「作成」するたび5ポイント獲得！</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-sheet>
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
              <v-card-text>
                電気やガス、水道などのライフラインが止まった場合や、避難生活が必要になったときのために防災用品を備えましょう。<br>
                家族情報を登録すると、必要な備蓄品の数量を計算して一覧で確認できます。
              </v-card-text>
              <v-sheet outlined color="#FFD54F" class="pa-1">
                <v-card flat>
                  <v-list>
                    <v-list-item>
                      <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                      <v-list-item-content>
                        <v-list-item-title class="wrap-text">各備蓄品の「完了！」をクリックして各1ポイント獲得！</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-sheet>
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
              <v-card-text>
                災害時に役立つ記事をジャンルごとに作成できます。<br>
                また、他の人の書いた記事をお気に入りすることでマイ記事に登録し、マイページからいつでも確認できます。<br>
                もしものときに備えて作成したり、読んでお気に入りしたりして備えておきましょう。
              </v-card-text>
              <v-sheet outlined color="#FFD54F" class="pa-1">
                <v-card flat>
                  <v-list>
                    <v-list-item>
                      <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                      <v-list-item-content>
                        <v-list-item-title class="wrap-text">
                          記事を作成する：5ポイント獲得！<br>
                          記事をいいねする：1ポイント獲得！<br>
                          記事をいいねしてもらう：1ポイント獲得！
                        </v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-sheet>
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

<style lang="scss" scoped>
.wrap-text {
  word-break: break-all;
  white-space: normal;
}
</style>
