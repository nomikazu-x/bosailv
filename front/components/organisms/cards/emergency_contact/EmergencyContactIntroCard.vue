<template>
  <v-card outlined tile class="pa-4">
    <v-row align="center">
      <v-col cols="12">
        <h1 class="main-heading mt-5 text-center">緊急時連絡先を確認しよう</h1>
        <v-divider color="#117768" />
      </v-col>
      <v-col cols="12">
        <div class="main-heading font-weight-bold">
          １）安否確認サービス（NTTグループ）
        </div>
        <v-card-text>
          災害時に限り安否情報の登録・確認ができます。
        </v-card-text>
      </v-col>
      <v-col cols="12">
        <v-card outlined tile color="#DFEEE5">
          <v-card-text>
            <a class="text-decoration-none" href="https://group.ntt/jp/disaster/service/171.html" target="_blank" rel="noopener noreferrer">
              <div class="main-heading font-weight-bold" style="color: #117768;">
                ・災害用伝言ダイヤル 171
              </div>
            </a>
            音声で安否情報を登録・確認できます。
          </v-card-text>
          <v-card-text>
            <a class="text-decoration-none" href="https://www.web171.jp/" target="_blank" rel="noopener noreferrer">
              <div class="main-heading font-weight-bold" style="color: #117768;">
                ・災害用伝言板（web171）
              </div>
            </a>
            インターネット上で安否情報を登録・確認できます。
          </v-card-text>
          <v-card-text>
            <a class="text-decoration-none" href="https://anpi.jp/top" target="_blank" rel="noopener noreferrer">
              <div class="main-heading font-weight-bold" style="color: #117768;">
                ・J-anpi 安否情報まとめて検索
              </div>
            </a>
            災害用伝言板（web171）や、各携帯電話会社が提供するサービスで登録された安否情報などを確認できます。
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12">
        <div class="main-heading font-weight-bold">
          2）消防・救急
        </div>
      </v-col>
      <v-col cols="12">
        <v-card outlined tile color="#DFEEE5">
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・消防機関への緊急通報 119</div>
            消防車・救急車を呼ぶときに使います。
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・救急相談センター #7119</div>
            救急車を呼んだほうが良いか迷ったときの相談窓口です。
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12">
        <div class="main-heading font-weight-bold">
          3）海での事故
        </div>
      </v-col>
      <v-col cols="12">
        <v-card outlined tile color="#DFEEE5">
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・海上保安庁 118</div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" class="mt-5">
        <div class="main-heading font-weight-bold">
          4）あなただけの緊急時連絡先を登録してみましょう！
        </div>
        <v-list>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-checkbox-marked-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">下のフォームから必要事項を入力し、緊急時連絡先を登録して、災害時すぐに連絡できるようにしておきましょう。</v-list-item-title>
              <v-list-item-subtitle class="wrap-text">
                ※電話番号は半角ハイフン（-）を含めてください。例：012-3456-7890
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#FFD54F">mdi-alert</v-icon>
            <v-list-item-content>
              <v-list-item-subtitle class="wrap-text">
                <NuxtLink to="/signup">ログイン</NuxtLink>しなければ表示されません。<br>
                緊急時連絡先登録上限数は5個です。<br>
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
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
                  <v-list-item-title class="wrap-text">緊急時連絡先を「作成」するたび5ポイント獲得！</v-list-item-title>
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
export default {
  name: 'HazardMapIntroCard'
}
</script>

<style lang="scss" scoped>
.wrap-text {
  word-break: break-all;
  white-space: normal;
}
</style>
