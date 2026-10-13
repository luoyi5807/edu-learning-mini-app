<template>
  <view class="app-shell">
    <!-- 常驻顶部栏（透明→白，随当前面板滚动） -->
    <view
      class="nav-bar"
      :class="{ 'nav-bar-opaque': navBarOpaque }"
      :style="{ paddingTop: statusBarHeight + 'px' }"
    >
      <view
        class="nav-bar-inner"
        :style="{ height: navContentHeight + 'px', paddingRight: capsuleReserve + 'px' }"
      >
        <view v-if="activeTab === 'home'" class="nav-left">
          <text class="nav-brand">学习平台</text>
          <text class="nav-divider">|</text>
          <text class="nav-sub">官方小程序</text>
        </view>
        <view v-else-if="activeTab === 'profile'" class="nav-head">
          <text class="page-title">个人主页</text>
          <view class="bell-btn" @tap="handleNotification">
            <text class="bell-icon">🔔</text>
            <view class="bell-dot" v-if="hasUnread"></view>
          </view>
        </view>
        <view v-else class="nav-head">
          <text class="page-title">{{ currentTabLabel }}</text>
        </view>
      </view>
    </view>

    <!-- 内容面板：各自独立滚动，v-show 常驻不销毁 -->
    <scroll-view class="panel" scroll-y :style="{ top: panelTop }" :hidden="activeTab !== 'home'" @scroll="onScroll">
      <HomePanel />
    </scroll-view>
    <scroll-view class="panel" scroll-y :style="{ top: panelTop }" :hidden="activeTab !== 'profile'" @scroll="onScroll">
      <ProfilePanel />
    </scroll-view>
    <scroll-view class="panel" scroll-y :style="{ top: panelTop }" :hidden="!isOtherTab" @scroll="onScroll">
      <view class="coming-soon"><text class="coming-soon-text">{{ currentTabLabel }}模块开发中</text></view>
    </scroll-view>

    <!-- 常驻底部导航（四色规范） -->
    <view class="tab-bar">
      <view
        v-for="tab in tabs"
        :key="tab.key"
        class="tab-item"
        @tap="handleTabChange(tab)"
      >
        <view class="tab-icon-wrap" :style="activeTab === tab.key ? { backgroundColor: tab.activeBg } : {}">
          <text class="tab-icon" :style="activeTab === tab.key ? { color: tab.activeColor } : {}">{{ tab.icon }}</text>
        </view>
        <text class="tab-label" :style="activeTab === tab.key ? { color: tab.activeColor } : {}">{{ tab.label }}</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import HomePanel from '@/components/HomePanel.vue'
import ProfilePanel from '@/components/ProfilePanel.vue'

/* ===== 固定栏高度（含状态栏 + 胶囊区） ===== */
const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const capsuleReserve = ref<number>(100)

const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) {
  navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
  capsuleReserve.value = sysInfo.windowWidth - menuButton.left + 8
}
// #endif

const panelTop = computed<string>(() => (statusBarHeight.value + navContentHeight.value) + 'px')

/* ===== Tab 切换（不跳转，仅切面板，顶/底栏常驻） ===== */
interface TabItem { key: string; label: string; icon: string; activeColor: string; activeBg: string }
const activeTab = ref<string>('home')
const tabs: TabItem[] = [
  { key: 'home', label: '首页', icon: '⌂', activeColor: '#282840', activeBg: '#E3E8FB' },
  { key: 'video', label: '视频', icon: '▶', activeColor: '#0E6E78', activeBg: '#D9F0F3' },
  { key: 'community', label: '社区', icon: '💬', activeColor: '#A8453C', activeBg: '#FBE4E0' },
  { key: 'profile', label: '个人主页', icon: '👤', activeColor: '#96650C', activeBg: '#FBEFD2' }
]

const currentTabLabel = computed<string>(() => tabs.find((t) => t.key === activeTab.value)?.label || '')
const isOtherTab = computed<boolean>(() => activeTab.value === 'video' || activeTab.value === 'community')

function handleTabChange(tab: TabItem) {
  if (tab.key === activeTab.value) return
  activeTab.value = tab.key
  scrollTop.value = 0
}

/* ===== 顶栏滚动变白 ===== */
const scrollTop = ref<number>(0)
const navBarOpaque = computed<boolean>(() => scrollTop.value > 40)
function onScroll(e: any) { scrollTop.value = e.detail.scrollTop }

const hasUnread = ref<boolean>(true)
function handleNotification() { uni.showToast({ title: '消息通知开发中', icon: 'none' }) }
</script>

<style lang="scss" scoped>
.app-shell {
  position: relative;
  min-height: 100vh;
  background-color: $edu-bg;
}

.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 99;
  background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; justify-content: space-between; padding-left: 32rpx; }

.nav-left { display: flex; align-items: center; }
.nav-brand { font-size: 38rpx; font-weight: 700; color: $edu-text-primary; }
.nav-divider { font-size: 30rpx; color: $edu-text-hint; margin: 0 12rpx; }
.nav-sub { font-size: 28rpx; color: $edu-text-secondary; }

.nav-head { display: flex; align-items: center; justify-content: space-between; width: 100%; }
.page-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; }
.bell-btn { position: relative; width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.bell-icon { font-size: 40rpx; }
.bell-dot { position: absolute; top: 14rpx; right: 16rpx; width: 14rpx; height: 14rpx; border-radius: 50%; background-color: $edu-accent-coral; }

.panel {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  box-sizing: border-box;
}

.coming-soon { height: 60vh; display: flex; align-items: center; justify-content: center; }
.coming-soon-text { font-size: 30rpx; color: $edu-text-hint; }

.tab-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: space-around;
  height: 96rpx;
  box-sizing: content-box;
  padding-bottom: env(safe-area-inset-bottom);
  background-color: $edu-surface;
  border-top: 2rpx solid $edu-divider;
  z-index: 100;
}
.tab-item { display: flex; flex-direction: column; align-items: center; justify-content: center; }
.tab-icon-wrap { width: 80rpx; height: 44rpx; display: flex; align-items: center; justify-content: center; border-radius: 22rpx; margin-bottom: 2rpx; }
.tab-icon { font-size: 32rpx; color: $edu-tab-unselected; }
.tab-label { font-size: 20rpx; color: $edu-tab-unselected; }
</style>