<template>
  <TwoColumnContainer
    :left-cols="12"
    :left-sm="8"
    :right-cols="12"
    :right-sm="4"
  >
    <template #top>
      <TheLoading v-if="loading" />
      <TheMessage v-if="!loading" :alert="alert" :notice="notice" />
      <TopSlide v-if="!loading" />
    </template>

    <template v-if="!loading" #left>
      <TopTransitionCard />
      <UserTaskListCard v-if="$auth.loggedIn" />
      <TaskListCard v-else />
      <NewArticleListCard />
      <GenreImageListCardWithTitle />
    </template>

    <template v-if="!loading" #right>
      <DefaultRightColumnTemplate />
    </template>
  </TwoColumnContainer>
</template>

<script>
import Application from '~/plugins/application.js'
import TwoColumnContainer from '~/components/molecules/containers/TwoColumnContainer.vue'
import TheLoading from '~/components/organisms/application/TheLoading.vue'
import TheMessage from '~/components/organisms/application/TheMessage.vue'
import TopSlide from '~/components/organisms/slide/TopSlide.vue'
import TopTransitionCard from '~/components/organisms/cards/TopTransitionCard.vue'
import UserTaskListCard from '~/components/organisms/cards/user/UserTaskListCard.vue'
import TaskListCard from '~/components/organisms/cards/task/TaskListCard.vue'
import NewArticleListCard from '~/components/organisms/cards/article/NewArticleListCard.vue'
import GenreImageListCardWithTitle from '~/components/organisms/cards/genre/GenreImageListCardWithTitle.vue'
import DefaultRightColumnTemplate from '~/components/templates/DefaultRightColumnTemplate.vue'

export default {
  name: 'Index',

  components: {
    TwoColumnContainer,
    TheLoading,
    TheMessage,
    TopSlide,
    TopTransitionCard,
    UserTaskListCard,
    TaskListCard,
    NewArticleListCard,
    GenreImageListCardWithTitle,
    DefaultRightColumnTemplate
  },

  mixins: [Application],

  created () {
    this.loading = false
  }
}
</script>
