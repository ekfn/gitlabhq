<script>
import { GlLoadingIcon } from '@gitlab-org/gitlab-ui';
import eventHub from '../../event_hub';
import statusIcon from '../mr_widget_status_icon.vue';

export default {
  name: 'MRWidgetAutoMergeFailed',
  components: {
    statusIcon,
    GlLoadingIcon,
  },
  props: {
    mr: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      isRefreshing: false,
    };
  },
  methods: {
    refreshWidget() {
      this.isRefreshing = true;
      eventHub.$emit('MRWidgetUpdateRequested', () => {
        this.isRefreshing = false;
      });
    },
  },
};
</script>
<template>
  <div class="mr-widget-body media">
    <status-icon status="warning" />
    <div class="media-body space-children">
      <span class="bold">
        <template v-if="mr.mergeError">{{ mr.mergeError }}.</template>
        {{ s__("mrWidget|This merge request failed to be merged automatically") }}
      </span>
      <button
        :disabled="isRefreshing"
        type="button"
        class="btn btn-sm btn-default"
        @click="refreshWidget"
      >
        <gl-loading-icon
          v-if="isRefreshing"
          :inline="true"
        />
        {{ s__("mrWidget|Refresh") }}
      </button>
    </div>
  </div>
</template>
