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
              <v-col v-for="info in shelterInfo" :key="info.id" cols="1.5">
                <div class="text-center">
                  <v-icon class="mb-1" color="#117768">{{ info.icon }}</v-icon>
                </div>
                <div class="text-caption text-center">{{ info.type }}</div>
                <div v-if="info.is_selected" class="text-caption text-center font-weight-bold">○</div>
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

  computed: {
    shelterInfo () {
      if (this.selectedShelter !== null) {
        return [
          { id: 1, type: '洪水', is_selected: this.selectedShelter.flood, icon: 'mdi-home-flood' },
          { id: 2, type: '土砂災害', is_selected: this.selectedShelter.landslide, icon: 'mdi-landslide' },
          { id: 3, type: '高潮', is_selected: this.selectedShelter.storm_surge, icon: 'mdi-tsunami' },
          { id: 4, type: '地震', is_selected: this.selectedShelter.earthquake, icon: 'mdi-image-broken-variant' },
          { id: 5, type: '津波', is_selected: this.selectedShelter.tsunami, icon: 'mdi-tsunami' },
          { id: 6, type: '火事', is_selected: this.selectedShelter.fire, icon: 'mdi-fire' },
          { id: 7, type: '内水氾濫', is_selected: this.selectedShelter.inland_flood, icon: 'mdi-home-flood' },
          { id: 8, type: '火山噴火', is_selected: this.selectedShelter.volcano, icon: 'mdi-volcano' }
        ]
      } else {
        return null
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
