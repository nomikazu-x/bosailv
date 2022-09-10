<template>
  <v-card outlined tile class="pa-4">
    <v-row align="center">
      <v-col cols="12">
        <h1 class="main-heading mt-5 text-center">避難所を確認しよう</h1>
        <v-divider color="#117768" />
      </v-col>
      <v-col cols="12">
        <v-card-text>
          もし、大きな災害に遭遇したとき、一体どこに避難すればよいのか、みなさんはご存知ですか？<br>
          いざというときにあわてないように、自宅や働いている場所の近くにある避難場所と安全な避難経路を、しっかり確認しておきましょう。
        </v-card-text>
        <div class="text-center">
          <GreenBtn href="#shelter_map_search" class="my-2" large>
            さっそく探す
            <v-icon>mdi-chevron-right</v-icon>
          </GreenBtn>
        </div>
      </v-col>
      <v-col cols="12">
        <div class="main-heading font-weight-bold">
          １）避難所の種類
        </div>
        <v-card-text>
          各市町村では、あらかじめ災害時の避難場所を定めています。<br>
          避難指示が出たときには、速やかに避難場所に移動できるよう、市町村のホームページや、配布しているパンフレットなどで、あらかじめ位置などを確認しておきましょう。<br>
          避難所は、「指定緊急避難場所」「指定避難所」「福祉避難所」などに分けられます。
        </v-card-text>
      </v-col>
      <v-col cols="12">
        <v-card outlined tile color="#DFEEE5">
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・指定緊急避難場所</div>
            住民等の生命の安全の確保を目的として、緊急に避難する場所です。土砂災害、洪水、津波、地震等の災害種別ごとに指定されており、災害発生時はその災害に対応している指定緊急避難場所へ避難します。（自治体によっては、広域避難場所や一次避難場所を定めています。）
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・指定避難所</div>
            災害の危険性があり避難した住民等が、災害の危険性がなくなるまで必要な期間滞在し、または災害により自宅へ戻れなくなった住民等が一時的に滞在することを目的とした場所です。
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・福祉避難所</div>
            介護の必要な高齢者や障がい者など、一般の避難所では生活が困難である人を受け入れる福祉避難所が二次避難所として使用できる地域があります。市区町村などに確認をしておきましょう。
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" class="mt-5">
        <div class="main-heading font-weight-bold">
          ２）下の検索カードから検索・確認してみましょう！
        </div>
        <v-list>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-1-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title>検索したい災害種別を選択します。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-2-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title>検索したい都道府県を選択します。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-3-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">選択した都道府県の市町村一覧のセレクトボックスが出現するので、検索したい市町村を選択してください。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-4-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">「検索」ボタンをクリックして検索しましょう。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-5-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">検索フォームの下に、条件に合致した避難所のマップと一覧が表示されます。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-6-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">避難所の詳細を確認するには、マップのアイコンまたは避難所一覧から表示しましょう。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-7-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">
                実際に避難する避難所を見つけたら、避難所詳細ページの「マイ避難所に登録する」ボタンをクリックしましょう。
              </v-list-item-title>
              <v-list-item-subtitle>
                ※<NuxtLink to="/signup">ログイン</NuxtLink>しなければ表示されません。<br>
                ※マイ避難所登録上限数は5個です。確認はマイページからできます。<br>
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text"><NuxtLink to="/settings/profile">設定ページ</NuxtLink>で自分の出身市町村を設定すると、「自分の出身市町村で検索する」ボタンが出現して検索できるようになります。</v-list-item-title>
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
                  <v-list-item-title class="wrap-text">「マイ避難所に登録する」ボタンをクリックして5ポイント獲得！</v-list-item-title>
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
  name: 'HazardMapIntroCard',

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
