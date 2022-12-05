<template>
  <v-card outlined tile class="pa-4">
    <v-row align="center">
      <v-col cols="12">
        <h1 class="main-heading mt-5 text-center">家族会議を確認しよう</h1>
        <v-divider color="#117768" />
      </v-col>
      <v-col cols="12">
        <v-card-text>
          家庭によって生活スタイルはさまざまです。そこで、普段の生活を考えながら、災害時に困ることを家族で話し合えば、「必要なこと」が見えてきます。<br>
          いざというときに備えて、家族会議をしましょう。
        </v-card-text>
      </v-col>
      <v-col cols="12">
        <div class="main-heading font-weight-bold">
          １）家族会議の項目
        </div>
        <v-card-text>
          以下の項目について家族会議をし、メモしておきましょう。
        </v-card-text>
      </v-col>
      <v-col cols="12">
        <v-card outlined tile color="#DFEEE5">
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・非常時の連絡方法</div>
            災害伝言ダイヤル、携帯電話、ドアに張り紙、県外の知人・親戚
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・避難場所のルート</div>
            指定の避難場所、2次避難場所、各避難場所への具体的なルート
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・地震直後の家族の分担</div>
            家の中：まず身を守る体勢をとり、落下物による被害を防ぐ
            外へ出るとき：夫は大きい非常用持ち出し袋とブレーカーを落とす、私は子どもの保護と貴重品、母は自分用の持ち出し袋と家の戸締まり
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・誰かが下敷きになったら</div>
            近所の人、近くを歩いている人、町の消防団、避難所にいる人
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・家を離れるときにすること</div>
            ブレーカーを落とす、火元の確認とコンセントを抜く、戸や窓のカギを締める、避難先をドアや外壁に張る
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" class="mt-5">
        <div class="main-heading font-weight-bold">
          ２）家族会議をしてメモしましょう！
        </div>
        <v-list>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-1-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">下の「さっそくメモする」をクリックして、メモ用ページに移動します。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-2-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">各項目にメモし、「作成」から保存すると、いつでも確認できます。</v-list-item-title>
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
            <GreenBtn :to="toFamilyRule" class="my-2" large>
              さっそくメモする
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
                  <v-list-item-title class="wrap-text">家族会議の項目をメモし、「作成」をクリックして5ポイント獲得！</v-list-item-title>
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
  },

  computed: {
    toFamilyRule () {
      return this.$auth.user.is_completed_family_rule_task ? 'family_rule/edit' : 'family_rule/new'
    }
  }
}
</script>

<style lang="scss" scoped>
.wrap-text {
  word-break: break-all;
  white-space: normal;
}
</style>
