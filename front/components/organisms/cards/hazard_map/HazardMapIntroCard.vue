<template>
  <v-card outlined tile class="pa-4">
    <v-row align="center">
      <v-col cols="12">
        <h1 class="main-heading mt-8 text-center">ハザードマップを確認しよう</h1>
        <v-divider color="#117768" />
      </v-col>
      <v-col cols="12">
        <v-card-text>
          日本では、毎年のように自然災害が起こっており、危険な場所は全国にたくさんあります。<br>
          自分の周りにも起こりうることだと認識し、災害への備えとしてハザードマップの見方や市区町村のハザードマップの活用法について確認しましょう。
        </v-card-text>
        <div class="text-center">
          <GreenBtn href="#hazard_map_search" class="my-2" large>
            さっそく探す
            <v-icon>mdi-chevron-right</v-icon>
          </GreenBtn>
        </div>
      </v-col>
      <v-col cols="12">
        <v-sheet outlined color="#117768">
          <v-card outlined tile>
            <v-card-title style="color: #117768;">ハザードマップとは</v-card-title>
            <v-card-text>
              大雨、台風、地震などが起きた際に、浸水やがけ崩れなどの危険がある場所や、危険が迫ったときの避難経路や避難場所などを地図上にまとめたものです。
            </v-card-text>
          </v-card>
        </v-sheet>
      </v-col>
      <v-col cols="12">
        <v-card-text>
          災害は突然やってきます。思い立ったときにハザードマップを確認しておきましょう。
        </v-card-text>
      </v-col>
      <v-col cols="12">
        <h2 class="main-heading">ハザードマップの確認について</h2>
        <v-divider color="#117768" />
      </v-col>
      <v-col cols="12">
        <div class="main-heading font-weight-bold">
          １）ハザードマップの種類
        </div>
        <v-card-text>
          ハザードマップには、「洪水」「内水」「高潮」「津波」「土砂災害」「火山」などの種類があります。
        </v-card-text>
      </v-col>
      <v-col cols="12">
        <v-card outlined tile color="#DFEEE5">
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・洪水ハザードマップ</div>
            洪水ハザードマップでは、大雨などが原因で河川の水があふれたり、堤防が決壊した場合に浸水する恐れがある範囲や浸水の深さを知ることができます。
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・内水ハザードマップ</div>
            内水（ないすい）とは、大雨などで下水の限界を超え、排水することができなくなったことが原因で浸水することです。<br>
            台風や大雨により、雨水の処理ができなくなると、市街地内を流れる側溝や排水路、マンホールから水があふれ出し冠水してしまうことがあるため、内水の恐れがあるエリアをまとめています。
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・高潮ハザードマップ</div>
            高潮とは、台風や低気圧の影響で、海面の高さが通常よりも高くなる現象です。<br>
            海面の高さが高くなるので海水が防波堤を超える恐れがあり、台風などの規模によってはこれまで浸水がなかった地域でも被害が出る可能性があるため、危険エリアをまとめています。
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・津波ハザードマップ</div>
            津波によって浸水の危険があるエリアを示しています。<br>
            国内で発生した地震だけでなく、海外で起こった地震で津波の被害が起こるケースがあるため、地震があった際には津波情報もあわせて確認する必要があります。
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・土砂災害ハザードマップ</div>
            土砂災害は、雨が止んだあとも起こる可能性がある災害です。<br>
            がけ崩れなどで道路が封鎖される可能性もあるため、避難ルートもあわせて確認する必要があります。
          </v-card-text>
          <v-card-text>
            <div class="main-heading font-weight-bold" style="color: #117768;">・火山ハザードマップ</div>
            火山の噴火による噴石の落下、火砕流、土石流、火山ガスの発生、噴煙などの災害被害を受ける可能性がある地域を確認できます。<br>
            噴火がはじまったらすぐに避難が必要な範囲など、地域によっては避難行動に欠かせない情報も掲載しています。
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
              <v-list-item-title>まず、検索したい都道府県を選択します。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-2-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">次に、選択した都道府県の市町村一覧のセレクトボックスが出現するので、検索したい市町村を選択してください。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-3-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">「検索」ボタンをクリックして検索しましょう。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-4-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">検索フォームの下に、検索した市町村のハザードマップ一覧が表示されます。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-icon class="mr-2" color="#117768">mdi-numeric-5-circle</v-icon>
            <v-list-item-content>
              <v-list-item-title class="wrap-text">青字で記載されている災害種別は、ハザードマップが公開されていますので、クリックして市町村ハザードマップのページを表示しましょう。</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
        <v-divider />
      </v-col>
      <v-col cols="12">
        <v-sheet outlined color="#FFD54F" class="pa-1">
          <v-card outlined>
            <v-card-title>
              ポイント獲得方法
            </v-card-title>
            <v-list>
              <v-list-item>
                <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                <v-list-item-content>
                  <v-list-item-title class="wrap-text"><NuxtLink to="/settings/profile">設定ページ</NuxtLink>で自分の出身市町村を設定すると、「自分の出身市町村で検索する」ボタンが出現して検索できるようになります。</v-list-item-title>
                </v-list-item-content>
              </v-list-item>
              <v-list-item>
                <v-icon class="mr-2" color="#FFD54F">mdi-star-circle</v-icon>
                <v-list-item-content>
                  <v-list-item-title class="wrap-text">自分の出身市町村で検索すると、表示される「ハザードマップを確認した！」ボタンをクリックしてポイント獲得！</v-list-item-title>
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
