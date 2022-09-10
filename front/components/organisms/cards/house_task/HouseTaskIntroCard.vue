<template>
  <v-card outlined tile class="pa-4">
    <v-row align="center">
      <v-col cols="12">
        <h1 class="main-heading mt-5 text-center">おうち防災に取り組もう</h1>
        <v-divider color="#117768" />
      </v-col>
      <v-col cols="12">
        <v-card-text>
          阪神・淡路大震災時に、建物の中でけがをした人の約半数（46%）は家具の転倒、落下が原因だったという調査結果があります。<br>
          これにガラスの飛散によってけがを負った人（29％）を加えると、実に4分の3の人たちが家具やガラスでけがをしたことになります。<br>
          つまり、家具をしっかりと留めて、ガラスの飛散防止対策を施せば、震災時に多くの人はけがから身を守ることができます。
        </v-card-text>
      </v-col>
      <v-col cols="12">
        <h2 class="main-heading">おうち防災のチェックリスト</h2>
        <v-divider color="#117768" />
      </v-col>
      <v-col cols="12">
        <v-card-text>
          下のチェックリストを使用し、ご自宅の家具類の転倒・落下・移動防止対策を行いましょう。
        </v-card-text>
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
                  <v-list-item-title class="wrap-text">各防災SNSアカウントごとの「完了！」ボタンをクリックして1ポイント獲得！</v-list-item-title>
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
  name: 'HouseTaskIntroCard'
}
</script>

<style lang="scss" scoped>
.wrap-text {
  word-break: break-all;
  white-space: normal;
}
</style>
