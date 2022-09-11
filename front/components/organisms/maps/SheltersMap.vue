<template>
  <v-card v-if="shelters.length > 0" outlined tile class="mt-4 py-2">
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
        <v-row>
          <v-col cols="12">
            <h3 class="main-heading font-weight-bold my-2" style="color: #117768;">
              <NuxtLink :to="{ name: 'shelters-id___ja', params: { id: selectedShelter.id } }" class="text-decoration-none">
                {{ selectedShelter.name }}
              </NuxtLink>
            </h3>
            <div class="mb-2">{{ selectedShelter.address }}</div>
            <v-divider />
          </v-col>
          <v-col cols="12">
            <v-row no-gutters justify="center">
              <v-col cols="1">
                <v-icon class="mb-1" color="#117768">mdi-home-flood</v-icon>
                <div class="text-caption text-center">洪水</div>
                <div v-if="selectedShelter.flood" class="text-caption text-center font-weight-bold">○</div>
                <div v-else class="text-caption text-center">×</div>
              </v-col>
              <v-col cols="1" class="ml-2">
                <v-icon class="mb-1" color="#117768">mdi-landslide</v-icon>
                <div class="text-caption text-center">土砂災害</div>
                <div v-if="selectedShelter.landslide" class="text-caption text-center">○</div>
                <div v-else class="text-caption text-center">×</div>
              </v-col>
              <v-col cols="1" class="ml-2">
                <v-icon class="mb-1" color="#117768">mdi-tsunami</v-icon>
                <div class="text-caption text-center">高潮</div>
                <div v-if="selectedShelter.storm_surge" class="text-caption text-center">○</div>
                <div v-else class="text-caption text-center">×</div>
              </v-col>
              <v-col cols="1" class="ml-2">
                <v-icon class="mb-1" color="#117768">mdi-image-broken-variant</v-icon>
                <div class="text-caption text-center">地震</div>
                <div v-if="selectedShelter.earthquake" class="text-caption text-center">○</div>
                <div v-else class="text-caption text-center">×</div>
              </v-col>
              <v-col cols="1" class="ml-2">
                <v-icon class="mb-1" color="#117768">mdi-tsunami</v-icon>
                <div class="text-caption text-center">津波</div>
                <div v-if="selectedShelter.tsunami" class="text-caption text-center">○</div>
                <div v-else class="text-caption text-center">×</div>
              </v-col>
              <v-col cols="1" class="ml-2">
                <v-icon class="mb-1" color="#117768">mdi-fire</v-icon>
                <div class="text-caption text-center">火事</div>
                <div v-if="selectedShelter.fire" class="text-caption text-center">○</div>
                <div v-else class="text-caption text-center">×</div>
              </v-col>
              <v-col cols="1" class="ml-2">
                <v-icon class="mb-1" color="#117768">mdi-home-flood</v-icon>
                <div class="text-caption text-center">内水氾濫</div>
                <div v-if="selectedShelter.inland_flood" class="text-caption text-center">○</div>
                <div v-else class="text-caption text-center">×</div>
              </v-col>
              <v-col cols="1" class="ml-2">
                <v-icon class="mb-1" color="#117768">mdi-volcano</v-icon>
                <div class="text-caption text-center">火山噴火</div>
                <div v-if="selectedShelter.volcano" class="text-caption text-center">○</div>
                <div v-else class="text-caption text-center">×</div>
              </v-col>
            </v-row>
          </v-col>
        </v-row>
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
