<template>
  <v-card v-if="shelters !== null" outlined tile class="mt-4 py-2">
    <GmapMap
      map-type-id="roadmap"
      :center="centerInfo(shelters)"
      :zoom="14"
      :options="{
        zoomControl: true,
        mapTypeControl: false,
        scaleControl: false,
        streetViewControl: false,
        rotateControl: false,
        fullscreenControl: true,
      }"
      style="width: 500px; height: 350px; margin: auto"
    >
      <GmapMarker
        v-for="(shelter, index) in shelters"
        :key="index"
        :position="{ lat: parseFloat(shelter.latitude), lng: parseFloat(shelter.longitude) }"
        :clickable="true"
        @click="toggleInfoWindow(shelter, index)"
      />
      <GmapInfoWindow
        :options="infoOptions"
        :position="infoWindowPos"
        :opened="infoWinOpen"
        @closeClick="infoWinOpen = false"
      >
        <div>{{ selectedShelter.name }}</div>
        <NuxtLink :to="{ name: 'shelters-id___ja', params: { id: selectedShelter.id } }">詳細</NuxtLink>
      </GmapInfoWindow>
    </GmapMap>
  </v-card>
</template>

<script>
export default {
  name: 'SheltersMap',

  props: {
    shelters: {
      type: Array,
      default: () => []
    }
  },

  data () {
    return {
      selectedShelter: {},
      infoWindowPos: null,
      infoWinOpen: false,
      currentMidx: null,
      selectMarkerText: '',
      infoOptions: {
        minWidth: 200,
        pixelOffset: {
          width: 0,
          height: -35
        }
      }
    }
  },

  methods: {
    toggleInfoWindow (shelter, idx) {
      this.infoWindowPos = { lat: parseFloat(shelter.latitude), lng: parseFloat(shelter.longitude) }
      this.selectedShelter = shelter
      if (this.currentMidx === idx) {
        this.infoWinOpen = !this.infoWinOpen
      } else {
        this.infoWinOpen = true
        this.currentMidx = idx
      }
    },

    centerInfo (shelters) {
      return { lat: parseFloat(shelters[0].latitude), lng: parseFloat(shelters[0].longitude) }
    }
  }
}
</script>
