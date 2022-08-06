<template>
  <v-card outlined tile class="mt-4 py-2">
    <GmapMap
      map-type-id="roadmap"
      :center="center"
      :zoom="15"
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
      center: { lat: 34.7054595, lng: 137.6852776 },
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
      },
      selectedShelter: {}
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
    }
  }
}
</script>
