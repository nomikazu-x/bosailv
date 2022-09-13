<template>
  <v-card outlined tile class="pa-4">
    <v-row align="center">
      <v-col cols="12">
        <h1 class="main-heading mt-5 text-center">被災したときの備えをしよう</h1>
        <v-divider color="#117768" />
      </v-col>
      <v-col cols="12">
        <v-card-text>
          電気やガス、水道などのライフラインが止まった場合や、避難生活が必要になったときのために防災用品を備えましょう。
        </v-card-text>
      </v-col>
      <v-col cols="12">
        <v-card outlined tile color="#DFEEE5">
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">
              水・食料品
            </div>
            水：飲料水（1人1日3リットル）、給水タンク、給水袋<br>
            食料品：アルファ化米、レトルトご飯、缶詰（さばの味噌煮、野菜など）、レトルト食品（冷凍食品）、缶詰（果物、小豆など）、加熱無しで食べられる食品（かまぼこ、チーズなど）、栄養補助食品
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">
              調理補助品
            </div>
            カセットコンロ、カセットボンベ、マルチツール（缶切り・ナイフなど）
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">
              薬・衛生用品
            </div>
            薬：常備薬・市販薬、救急箱<br>
            衛生用品：簡易トイレ、トイレットペーパー、ティッシュペーパー、大型ビニール袋・ゴミ袋、除菌ウェットティッシュ
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">
              日用品
            </div>
            懐中電灯、乾電池、ライター、点火棒、マッチ、ロープ・ガムテープ、軍手、携帯電話・スマートフォンの予備バッテリー、手回し充電式などのラジオ、使い捨てコンタクトレンズ、生理用品、化粧品
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">
              乳幼児向け用品
            </div>
            スティックタイプの粉ミルク、離乳食（アレルギー対応）、おむつ、お尻拭き
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">
              高齢者向け用品
            </div>
            おかゆなどのやわらかい食品、高齢者用食品、入れ歯洗浄剤、常備薬（処方薬）、老眼鏡、お薬手帳、補聴器・予備の電池
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" class="mt-5">
        <div class="main-heading font-weight-bold" style=" color: #117768;">
          <v-icon class="mr-2" color="#117768">mdi-checkbox-marked-circle</v-icon>
          あなたの家族に必要な備蓄品・持ち出し品をチェックしよう！
        </div>
        <v-list>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-1-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">下の「家族情報を入力する」をクリックして、家族情報登録ページに移動します。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-2-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">家族情報を登録して、「備蓄品リストを確認する」をクリックして確認しましょう。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item v-if="!$auth.loggedIn">
            <v-icon class="mr-2" color="#FFD54F">mdi-alert</v-icon>
            <v-list-item-content>
              <v-list-item-subtitle class="wrap-text">
                <NuxtLink to="/signup">ログイン</NuxtLink>しなければ表示されません。
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
          <div v-else class="text-center">
            <GreenBtn to="stocks/edit" class="my-2" large>
              家族情報を入力する
              <v-icon>mdi-chevron-right</v-icon>
            </GreenBtn>
          </div>
        </v-list>
      </v-col>
      <v-col cols="12">
        <v-sheet outlined color="#FFD54F" class="pa-1">
          <v-card flat>
            <v-card-title>
              ポイント獲得方法
            </v-card-title>
            <v-list>
              <v-list-item>
                <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                <v-list-item-content>
                  <v-list-item-title class="wrap-text">各項目について備蓄できたら、「完了！」をクリックして各1ポイント獲得！</v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card>
        </v-sheet>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import GreenBtn from '~/components/atoms/btns/GreenBtn.vue'

export default {
  name: 'FamilyRuleIntroCard',

  components: {
    GreenBtn
  }
}
</script>

<style lang="scss" scoped>
.wrap-text {
  word-break: break-all;
  white-space: normal;
}
</style>
