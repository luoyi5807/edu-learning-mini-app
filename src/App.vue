<script setup lang="ts">
import { onLaunch, onShow, onHide } from "@dcloudio/uni-app";
import { initTheme } from "@/store/theme";
onLaunch(() => {
  initTheme();
});
onShow(() => {});
onHide(() => {});
</script>
<style lang="scss">
/* 主题变量：page 兜底浅色；页面根节点 .theme-light/.theme-dark 就近覆盖；
   系统深色时未绑定 class 的页面靠媒体查询兜底 */
page { @include eduThemeLight; }
.theme-light { @include eduThemeLight; }
.theme-dark { @include eduThemeDark; }
@media (prefers-color-scheme: dark) {
  page { @include eduThemeDark; }
}
</style>
