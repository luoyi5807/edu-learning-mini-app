/*
 Navicat Premium Dump SQL

 Source Server         : ruoyi
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : 43.142.9.214:3306
 Source Schema         : learning_platform

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 19/11/2026 09:25:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for QRTZ_BLOB_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `QRTZ_BLOB_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_BLOB_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CALENDARS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `QRTZ_CALENDARS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_CALENDARS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CRON_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `QRTZ_CRON_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_CRON_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_FIRED_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
CREATE TABLE `QRTZ_FIRED_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_FIRED_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_JOB_DETAILS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `QRTZ_JOB_DETAILS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_JOB_DETAILS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_LOCKS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `QRTZ_LOCKS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_LOCKS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SCHEDULER_STATE
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `QRTZ_SCHEDULER_STATE`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_SCHEDULER_STATE
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SIMPLE_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_SIMPLE_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SIMPROP_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_SIMPROP_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `QRTZ_TRIGGERS`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `QRTZ_JOB_DETAILS` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of QRTZ_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作 sub主子表操作）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int NULL DEFAULT 1 COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for learning_ad_view
-- ----------------------------
DROP TABLE IF EXISTS `learning_ad_view`;
CREATE TABLE `learning_ad_view`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `ad_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '广告唯一标识（广告位/广告ID）',
  `view_date` date NOT NULL COMMENT '观看日期（东八区）',
  `seconds` int NOT NULL DEFAULT 0 COMMENT '本次观看秒数',
  `points` int NOT NULL DEFAULT 0 COMMENT '发放积分',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_ad_date`(`user_id` ASC, `ad_id` ASC, `view_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分-广告观看去重' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_ad_view
-- ----------------------------
INSERT INTO `learning_ad_view` VALUES (4, 121, 'prod-test-ad-1', '2026-11-12', 15, 10, '2026-11-12 14:43:50');
INSERT INTO `learning_ad_view` VALUES (5, 112, '46D97695-B513-4A1D-9DFD-A55880CCE811', '2026-11-18', 81, 10, '2026-11-18 18:17:32');
INSERT INTO `learning_ad_view` VALUES (6, 112, 'F4A7C21C-E0B4-4307-81B8-C4748D934096', '2026-11-18', 48, 10, '2026-11-18 21:54:50');
INSERT INTO `learning_ad_view` VALUES (7, 112, '830E2E4D-9DEA-4277-A551-45C368C559B6', '2026-11-18', 41, 10, '2026-11-18 21:55:58');

-- ----------------------------
-- Table structure for learning_agreement
-- ----------------------------
DROP TABLE IF EXISTS `learning_agreement`;
CREATE TABLE `learning_agreement`  (
  `agreement_id` bigint NOT NULL AUTO_INCREMENT COMMENT '协议ID',
  `agreement_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '协议类型（user_agreement=用户协议 privacy_policy=隐私政策 about_us=关于我们）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '协议标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '协议正文（HTML）',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`agreement_id`) USING BTREE,
  INDEX `idx_agreement_type`(`agreement_type` ASC, `del_flag` ASC, `status` ASC, `order_num` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学习平台-平台协议（用户协议/隐私政策/关于我们）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_agreement
-- ----------------------------
INSERT INTO `learning_agreement` VALUES (1, 'user_agreement', '用户协议', '<h2>用户协议</h2><p>欢迎使用本学习平台。本协议约定您与平台之间的权利与义务，请仔细阅读。</p><p>（内容由管理员在后台「协议管理」中完善）</p>', 1, '0', '0', 'admin', '2026-11-17 16:14:18', 'admin', '2026-11-18 14:43:39', '系统初始化');
INSERT INTO `learning_agreement` VALUES (2, 'privacy_policy', '隐私政策', '<h2>隐私政策</h2><p>我们重视您的个人信息保护。本政策说明我们如何收集、使用和保护您的信息。</p><p>（内容由管理员在后台「协议管理」中完善）</p>', 2, '0', '0', 'admin', '2026-11-17 16:14:19', '', NULL, '系统初始化');
INSERT INTO `learning_agreement` VALUES (3, 'about_us', '关于我们', '<h2>关于我们</h2><p>本学习平台致力于提供课程、社区与短视频学习体验。</p><p>（内容由管理员在后台「协议管理」中完善）</p>', 3, '0', '0', 'admin', '2026-11-17 16:14:19', '', NULL, '系统初始化');

-- ----------------------------
-- Table structure for learning_api_token
-- ----------------------------
DROP TABLE IF EXISTS `learning_api_token`;
CREATE TABLE `learning_api_token`  (
  `token_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问令牌（UUID 去横线，不可猜）',
  `user_id` bigint NOT NULL COMMENT '用户ID（逻辑关联 sys_user.user_id）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '签发时的客户端IP（排查 Token 泄露用）',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '签发时间',
  PRIMARY KEY (`token_id`) USING BTREE,
  UNIQUE INDEX `uk_learning_api_token`(`token` ASC) USING BTREE,
  INDEX `idx_learning_api_token_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 571 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台API访问令牌表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_api_token
-- ----------------------------
INSERT INTO `learning_api_token` VALUES (107, '985ffb85c95548a99fd455b315f788ec', 106, '58.16.41.98', '2026-11-14 16:01:43', '2026-10-15 16:01:43');
INSERT INTO `learning_api_token` VALUES (108, '4d35d9a1837c4b46b4fc12e025b73547', 106, '58.16.41.98', '2026-11-14 16:06:22', '2026-10-15 16:06:22');
INSERT INTO `learning_api_token` VALUES (109, 'e97abcfa7f744bbf81b5fd51ca09450c', 106, '58.16.41.98', '2026-11-14 17:29:06', '2026-10-15 17:29:06');
INSERT INTO `learning_api_token` VALUES (117, '5e7a1e80b51b427e91c3b0773b4237ae', 114, '127.0.0.1', '2026-11-15 15:52:07', '2026-10-16 15:52:07');
INSERT INTO `learning_api_token` VALUES (129, '729b1fbb8e55419ab92d3dd9078fd764', 106, '58.16.41.98', '2026-11-18 11:41:50', '2026-10-19 11:41:50');
INSERT INTO `learning_api_token` VALUES (138, '89958369598b4843b6a26a6dfe40e057', 112, '127.0.0.1', '2026-11-19 12:51:34', '2026-10-20 12:51:34');
INSERT INTO `learning_api_token` VALUES (139, '0037477f72674f87a85fd9545b4552f8', 112, '127.0.0.1', '2026-11-19 12:52:41', '2026-10-20 12:52:41');
INSERT INTO `learning_api_token` VALUES (140, '3abada0c0bba465a8b9f348bb58a2126', 112, '127.0.0.1', '2026-11-19 13:18:00', '2026-10-20 13:18:00');
INSERT INTO `learning_api_token` VALUES (141, '4d5a260b2cd44ba385626472ac4b6d9f', 112, '127.0.0.1', '2026-11-19 14:13:36', '2026-10-20 14:13:36');
INSERT INTO `learning_api_token` VALUES (142, '6b7f8e881d924b9587fe7d9a503839fd', 112, '127.0.0.1', '2026-11-19 14:20:21', '2026-10-20 14:20:21');
INSERT INTO `learning_api_token` VALUES (143, 'ac9eed92b8b243c0aacc4693e9281a07', 112, '127.0.0.1', '2026-11-19 14:27:26', '2026-10-20 14:27:26');
INSERT INTO `learning_api_token` VALUES (144, 'fbc67482ac0041318e84edea2d182fed', 112, '127.0.0.1', '2026-11-19 14:27:52', '2026-10-20 14:27:52');
INSERT INTO `learning_api_token` VALUES (145, '6392b1a44f454328a97621c3dc09e62b', 112, '127.0.0.1', '2026-11-19 14:28:32', '2026-10-20 14:28:32');
INSERT INTO `learning_api_token` VALUES (146, '0221f998219d42ea9680f2b890b59d70', 112, '58.16.41.98', '2026-11-19 14:39:24', '2026-10-20 14:39:24');
INSERT INTO `learning_api_token` VALUES (147, '4f78f30222ff40fdba8f47fa868957a4', 112, '127.0.0.1', '2026-11-19 14:42:53', '2026-10-20 14:42:53');
INSERT INTO `learning_api_token` VALUES (148, '215607261e104d1694f1d3eef6ee5237', 112, '127.0.0.1', '2026-11-19 14:55:44', '2026-10-20 14:55:44');
INSERT INTO `learning_api_token` VALUES (149, 'd5c78dfb045445edade282f9533fbc65', 112, '127.0.0.1', '2026-11-19 15:04:41', '2026-10-20 15:04:41');
INSERT INTO `learning_api_token` VALUES (150, '3631b17a0d94494897ff7feadaca116d', 112, '58.16.41.98', '2026-11-19 17:14:48', '2026-10-20 17:14:48');
INSERT INTO `learning_api_token` VALUES (151, '4bc6ff1ed9cd446e95c2448717110adb', 112, '127.0.0.1', '2026-11-19 17:36:25', '2026-10-20 17:36:25');
INSERT INTO `learning_api_token` VALUES (169, 'c42eadea629343db87d9d9111e5b57c1', 112, '58.16.41.98', '2026-11-21 15:55:08', '2026-10-22 15:55:08');
INSERT INTO `learning_api_token` VALUES (170, 'b7058d1325a64a33b24aa5cd0771deb1', 112, '58.16.41.98', '2026-11-21 15:58:11', '2026-10-22 15:58:11');
INSERT INTO `learning_api_token` VALUES (171, 'e09f226480a14337a69fde69f7c690eb', 112, '220.197.72.77', '2026-11-21 16:17:07', '2026-10-22 16:17:07');
INSERT INTO `learning_api_token` VALUES (172, 'd5f26d8a6eb648f0a6b55b325411722e', 112, '127.0.0.1', '2026-11-21 16:22:31', '2026-10-22 16:22:31');
INSERT INTO `learning_api_token` VALUES (173, 'e0b5177854574ee0bd95f5ddbef47f87', 112, '127.0.0.1', '2026-11-21 16:22:39', '2026-10-22 16:22:39');
INSERT INTO `learning_api_token` VALUES (174, 'ccaa3c354d8f4a5ab69f1e7457d28407', 112, '192.168.100.110', '2026-11-21 16:28:47', '2026-10-22 16:28:47');
INSERT INTO `learning_api_token` VALUES (175, 'c329defad2e54d219988cbcacbcb17a0', 112, '192.168.100.110', '2026-11-21 17:47:35', '2026-10-22 17:47:35');
INSERT INTO `learning_api_token` VALUES (177, '4092fbd5adcf44ad98997a8045f97098', 115, '127.0.0.1', '2026-11-22 10:14:46', '2026-10-23 10:14:46');
INSERT INTO `learning_api_token` VALUES (181, '6f844e4ca6024f6e83dcbc980db311d3', 115, '127.0.0.1', '2026-11-22 10:50:46', '2026-10-23 10:50:46');
INSERT INTO `learning_api_token` VALUES (185, '2f70e934e09445068cf8e263b48639b4', 112, '127.0.0.1', '2026-11-25 20:25:26', '2026-10-26 20:25:26');
INSERT INTO `learning_api_token` VALUES (186, '958fc41408c84424941d0fbda4f2555c', 112, '127.0.0.1', '2026-11-25 20:52:32', '2026-10-26 20:52:32');
INSERT INTO `learning_api_token` VALUES (187, '1a7f8b937e404049b24f648fa3b4b9c0', 112, '127.0.0.1', '2026-11-25 21:24:53', '2026-10-26 21:24:53');
INSERT INTO `learning_api_token` VALUES (188, '574fa41aede14020bc70d007b90bfff7', 112, '127.0.0.1', '2026-11-25 21:49:35', '2026-10-26 21:49:35');
INSERT INTO `learning_api_token` VALUES (189, '664343e039ac4afeb0a38b2cda7fa328', 115, '127.0.0.1', '2026-11-26 09:07:01', '2026-10-27 09:07:01');
INSERT INTO `learning_api_token` VALUES (190, '3bfbc18214ec487bb85af5cb0bb1322f', 115, '127.0.0.1', '2026-11-26 09:27:49', '2026-10-27 09:27:49');
INSERT INTO `learning_api_token` VALUES (191, 'ae8a14689f4c4b13af924584f90187be', 115, '127.0.0.1', '2026-11-26 09:27:49', '2026-10-27 09:27:49');
INSERT INTO `learning_api_token` VALUES (192, '3bbe4b3b9c5248a4a6967e731d08bbee', 115, '127.0.0.1', '2026-11-26 09:28:35', '2026-10-27 09:28:35');
INSERT INTO `learning_api_token` VALUES (194, '6ece1a5c046949f88376ec139cef2985', 112, '127.0.0.1', '2026-11-26 09:34:15', '2026-10-27 09:34:15');
INSERT INTO `learning_api_token` VALUES (195, '98527a976673416986bd24c61479f6b4', 117, '127.0.0.1', '2026-11-26 09:36:28', '2026-10-27 09:36:28');
INSERT INTO `learning_api_token` VALUES (196, '8d80a766617548c5b3074bd7be7c0050', 112, '127.0.0.1', '2026-11-26 09:37:29', '2026-10-27 09:37:29');
INSERT INTO `learning_api_token` VALUES (197, '2c89a79f41f749f1a5368212da4d1001', 115, '127.0.0.1', '2026-11-26 09:41:20', '2026-10-27 09:41:20');
INSERT INTO `learning_api_token` VALUES (198, '76985cc6ea44463fb2726946647b6728', 115, '127.0.0.1', '2026-11-26 09:41:41', '2026-10-27 09:41:41');
INSERT INTO `learning_api_token` VALUES (201, 'e08f54a6b8ed42fb95a2b22cede6ec96', 112, '127.0.0.1', '2026-11-26 10:05:48', '2026-10-27 10:05:48');
INSERT INTO `learning_api_token` VALUES (202, 'f19928b1f43d44419a244020cde9ea4a', 112, '127.0.0.1', '2026-11-26 10:12:07', '2026-10-27 10:12:07');
INSERT INTO `learning_api_token` VALUES (203, 'e50bf3458e30487082bf4dae9e4909d7', 112, '127.0.0.1', '2026-11-26 10:13:02', '2026-10-27 10:13:02');
INSERT INTO `learning_api_token` VALUES (204, 'c86154f68ea04ab88a02e71fefb04deb', 112, '127.0.0.1', '2026-11-26 10:15:49', '2026-10-27 10:15:49');
INSERT INTO `learning_api_token` VALUES (205, '31ec6c6dc0864e72be8fac25b8b58825', 112, '127.0.0.1', '2026-11-26 10:40:26', '2026-10-27 10:40:26');
INSERT INTO `learning_api_token` VALUES (207, '90608173adb447eda9bd7526feefc64f', 112, '127.0.0.1', '2026-11-26 10:42:00', '2026-10-27 10:42:00');
INSERT INTO `learning_api_token` VALUES (209, 'de9937b8deb04c8fbf06889d66d2b682', 112, '127.0.0.1', '2026-11-26 10:49:35', '2026-10-27 10:49:35');
INSERT INTO `learning_api_token` VALUES (215, 'cb8c83d43da34b85a3327f8d24efedeb', 112, '58.16.41.98', '2026-11-26 11:08:32', '2026-10-27 11:08:32');
INSERT INTO `learning_api_token` VALUES (216, 'bb25b69ff40b4d05b59724ec70cdc717', 112, '127.0.0.1', '2026-11-26 11:08:45', '2026-10-27 11:08:45');
INSERT INTO `learning_api_token` VALUES (222, '64576786fd6d4a8ebb6ae58a720ce292', 112, '127.0.0.1', '2026-11-26 14:15:25', '2026-10-27 14:15:25');
INSERT INTO `learning_api_token` VALUES (227, 'a6878b4cc9214d6d9db9b86938b87deb', 111, '58.16.41.98', '2026-11-26 14:19:20', '2026-10-27 14:19:20');
INSERT INTO `learning_api_token` VALUES (228, 'af56c49f686349b2acf298f8fb324275', 112, '127.0.0.1', '2026-11-26 14:33:34', '2026-10-27 14:33:34');
INSERT INTO `learning_api_token` VALUES (229, '9ac407dced8d44df91668b4902697f48', 112, '127.0.0.1', '2026-11-26 14:45:23', '2026-10-27 14:45:23');
INSERT INTO `learning_api_token` VALUES (230, 'b9d70055a92a4c0f8dffb2c49d79fa49', 112, '127.0.0.1', '2026-11-26 14:45:52', '2026-10-27 14:45:52');
INSERT INTO `learning_api_token` VALUES (231, '8d0d7c019d054cfbb702c24d223a5e35', 112, '127.0.0.1', '2026-11-26 14:54:08', '2026-10-27 14:54:08');
INSERT INTO `learning_api_token` VALUES (232, '722efdaf12754d62ad42e82d3b2a47c5', 112, '127.0.0.1', '2026-11-26 14:59:37', '2026-10-27 14:59:37');
INSERT INTO `learning_api_token` VALUES (233, '19f431202b7842ceac14eb32f76efe34', 112, '127.0.0.1', '2026-11-26 15:01:18', '2026-10-27 15:01:18');
INSERT INTO `learning_api_token` VALUES (235, '3a474db311314bafbac126617b7d3430', 112, '127.0.0.1', '2026-11-26 15:32:23', '2026-10-27 15:32:23');
INSERT INTO `learning_api_token` VALUES (236, 'ee502e1adae24cc295d00d0b373f59d3', 115, '127.0.0.1', '2026-11-26 15:47:59', '2026-10-27 15:47:59');
INSERT INTO `learning_api_token` VALUES (237, '1a96a50ab0e34de2aa17fd85d87cd9ff', 111, '127.0.0.1', '2026-11-26 15:50:43', '2026-10-27 15:50:43');
INSERT INTO `learning_api_token` VALUES (238, '022933618be94734ad99c214ec5e3df1', 115, '127.0.0.1', '2026-11-26 16:05:11', '2026-10-27 16:05:11');
INSERT INTO `learning_api_token` VALUES (239, 'c5842bf29df04dd598d90ea76ccc8474', 115, '127.0.0.1', '2026-11-26 16:05:31', '2026-10-27 16:05:31');
INSERT INTO `learning_api_token` VALUES (240, '6e0cf33900c0426e8cc61a6fa2a827b5', 115, '127.0.0.1', '2026-11-26 17:04:25', '2026-10-27 17:04:25');
INSERT INTO `learning_api_token` VALUES (241, '7bc58acd5e614df1bb289cd00f88c149', 111, '35.79.25.92', '2026-11-26 17:30:08', '2026-10-27 17:30:08');
INSERT INTO `learning_api_token` VALUES (242, '27f41f6e8c9b4bd6a70248617e9bbbd4', 115, '127.0.0.1', '2026-11-26 17:31:27', '2026-10-27 17:31:27');
INSERT INTO `learning_api_token` VALUES (243, '7521532850f844b58e41d4f3c730992b', 111, '35.79.25.92', '2026-11-26 17:37:49', '2026-10-27 17:37:49');
INSERT INTO `learning_api_token` VALUES (244, '8d70b5e9281940b0826e9c402b687f4f', 115, '127.0.0.1', '2026-11-26 17:38:09', '2026-10-27 17:38:09');
INSERT INTO `learning_api_token` VALUES (245, 'a5073c0cd6ab44348915c275c4bd51eb', 115, '127.0.0.1', '2026-11-26 17:55:33', '2026-10-27 17:55:33');
INSERT INTO `learning_api_token` VALUES (252, '0af0083bb2c642bfaab253a23da48b42', 112, '127.0.0.1', '2026-11-27 09:24:19', '2026-10-28 09:24:19');
INSERT INTO `learning_api_token` VALUES (253, '729a3797f8e9437e91ee11d20fe8589f', 115, '127.0.0.1', '2026-11-27 09:28:57', '2026-10-28 09:28:57');
INSERT INTO `learning_api_token` VALUES (254, '758c4864075e4234878eff8de5487191', 112, '127.0.0.1', '2026-11-27 09:36:51', '2026-10-28 09:36:51');
INSERT INTO `learning_api_token` VALUES (255, 'a6e13995986d4a25995dafa9af895009', 111, '43.142.9.214', '2026-11-27 09:47:33', '2026-10-28 09:47:33');
INSERT INTO `learning_api_token` VALUES (256, '2bb7ebe930b841b196c92dcf8d844ed1', 112, '127.0.0.1', '2026-11-27 10:18:39', '2026-10-28 10:18:39');
INSERT INTO `learning_api_token` VALUES (257, '6a374ea17bec406fb57928e98c8c252e', 112, '127.0.0.1', '2026-11-27 10:20:19', '2026-10-28 10:20:19');
INSERT INTO `learning_api_token` VALUES (258, '019d009f3b9645f9bbfff320ff13f61d', 112, '58.16.41.98', '2026-11-27 10:20:22', '2026-10-28 10:20:22');
INSERT INTO `learning_api_token` VALUES (259, '83040cf36a6d49a8ad4ec091f307cd7d', 112, '127.0.0.1', '2026-11-27 10:33:27', '2026-10-28 10:33:27');
INSERT INTO `learning_api_token` VALUES (260, '0f6640c802dc447fb9e057971a110bdb', 112, '127.0.0.1', '2026-11-27 10:38:59', '2026-10-28 10:38:59');
INSERT INTO `learning_api_token` VALUES (261, '2b110ebd9a59427db946294f77c94bf5', 112, '127.0.0.1', '2026-11-27 10:39:01', '2026-10-28 10:39:01');
INSERT INTO `learning_api_token` VALUES (262, '213082701d694392b0a4cf755e79711d', 112, '127.0.0.1', '2026-11-27 10:40:08', '2026-10-28 10:40:08');
INSERT INTO `learning_api_token` VALUES (263, 'e183508a6c61482f9573b38582dfec8a', 112, '127.0.0.1', '2026-11-27 10:40:23', '2026-10-28 10:40:23');
INSERT INTO `learning_api_token` VALUES (264, '462e7ee9f3fc4357818abe9c49c58389', 112, '127.0.0.1', '2026-11-27 10:40:30', '2026-10-28 10:40:30');
INSERT INTO `learning_api_token` VALUES (265, '8d97d8282a754c81b6c874816badf3e2', 115, '127.0.0.1', '2026-11-27 10:46:15', '2026-10-28 10:46:15');
INSERT INTO `learning_api_token` VALUES (266, 'd26f830dcf3c4276bc8198cef7b3345d', 111, '58.16.41.98', '2026-11-27 10:46:14', '2026-10-28 10:46:14');
INSERT INTO `learning_api_token` VALUES (267, 'db61463e003542d5a07da7856e11a4dd', 115, '127.0.0.1', '2026-11-27 10:46:47', '2026-10-28 10:46:47');
INSERT INTO `learning_api_token` VALUES (268, '7b516a67cc7b43ea82358aff8911ce33', 111, '58.16.41.98', '2026-11-27 10:46:39', '2026-10-28 10:46:39');
INSERT INTO `learning_api_token` VALUES (269, '2f2adea5359b4998a3fbbaf07fc9b421', 111, '58.16.41.98', '2026-11-27 10:50:42', '2026-10-28 10:50:42');
INSERT INTO `learning_api_token` VALUES (270, '92d83e0402b545fd9b17a605067181ff', 112, '127.0.0.1', '2026-11-27 10:54:08', '2026-10-28 10:54:08');
INSERT INTO `learning_api_token` VALUES (271, '4a3b293b9b0843dcb34fbb5ff3184dac', 112, '127.0.0.1', '2026-11-27 10:55:38', '2026-10-28 10:55:38');
INSERT INTO `learning_api_token` VALUES (274, '5fab0c3ce9ed4ebd8554d469b764d1a0', 115, '127.0.0.1', '2026-11-27 11:45:00', '2026-10-28 11:45:00');
INSERT INTO `learning_api_token` VALUES (275, 'c3c77aeebac94aac9a664dcaefc1308f', 115, '127.0.0.1', '2026-11-27 11:45:16', '2026-10-28 11:45:16');
INSERT INTO `learning_api_token` VALUES (276, '0278fc04796446ee8c9a8e347d245809', 112, '127.0.0.1', '2026-11-27 14:05:10', '2026-10-28 14:05:10');
INSERT INTO `learning_api_token` VALUES (277, '32da649bd5ec4eae9f9ee9d3076c2230', 111, '127.0.0.1', '2026-11-27 14:05:26', '2026-10-28 14:05:26');
INSERT INTO `learning_api_token` VALUES (278, '3ed3261e11bb41028f35a4cea01c72b5', 115, '192.168.88.3', '2026-11-27 14:27:17', '2026-10-28 14:27:17');
INSERT INTO `learning_api_token` VALUES (280, '6c3f3b3e5188438698e9f8e014958186', 115, '127.0.0.1', '2026-11-27 14:32:26', '2026-10-28 14:32:26');
INSERT INTO `learning_api_token` VALUES (281, '70325726a5e34f8f8a87575cf604fb0b', 115, '127.0.0.1', '2026-11-27 14:35:10', '2026-10-28 14:35:10');
INSERT INTO `learning_api_token` VALUES (282, 'a0c3fd8ae0804710972352432e46d0e3', 115, '127.0.0.1', '2026-11-27 14:36:04', '2026-10-28 14:36:04');
INSERT INTO `learning_api_token` VALUES (284, 'f1aabb887543452baf4858239e571aa4', 115, '192.168.88.3', '2026-11-27 15:13:57', '2026-10-28 15:13:57');
INSERT INTO `learning_api_token` VALUES (285, '996b5de754674e30aaa2f60db57c8d2d', 115, '192.168.88.3', '2026-11-27 15:28:37', '2026-10-28 15:28:37');
INSERT INTO `learning_api_token` VALUES (286, '619e02d680614025beafc701e12ac660', 111, '127.0.0.1', '2026-11-27 15:35:10', '2026-10-28 15:35:10');
INSERT INTO `learning_api_token` VALUES (287, '50001d8413074888957d22a10394207f', 115, '192.168.88.3', '2026-11-27 15:36:17', '2026-10-28 15:36:17');
INSERT INTO `learning_api_token` VALUES (288, 'd2e40c3cc3744ec79ad03772a601c572', 115, '192.168.88.3', '2026-11-27 15:39:36', '2026-10-28 15:39:36');
INSERT INTO `learning_api_token` VALUES (289, '3ebddbd050444465b8aa48cbc0dfdd4f', 112, '127.0.0.1', '2026-11-27 15:40:40', '2026-10-28 15:40:40');
INSERT INTO `learning_api_token` VALUES (290, 'e9f482f232ab41148c331b2047476ce1', 112, '127.0.0.1', '2026-11-27 15:41:38', '2026-10-28 15:41:38');
INSERT INTO `learning_api_token` VALUES (291, 'a17afbe59e0747f98e25e031570db7f6', 111, '127.0.0.1', '2026-11-27 15:43:35', '2026-10-28 15:43:35');
INSERT INTO `learning_api_token` VALUES (292, 'd41c20be6bf74fa28f3b67f49b479d42', 115, '127.0.0.1', '2026-11-27 15:49:30', '2026-10-28 15:49:30');
INSERT INTO `learning_api_token` VALUES (293, '3c3aeff877514a2f98af5cc3e9536fd8', 112, '127.0.0.1', '2026-11-27 15:57:48', '2026-10-28 15:57:48');
INSERT INTO `learning_api_token` VALUES (294, 'dcdadb4a27774ae3b9feab9716ec284d', 112, '127.0.0.1', '2026-11-27 16:05:23', '2026-10-28 16:05:23');
INSERT INTO `learning_api_token` VALUES (295, 'd79ed52e9d484a04aa19e8272e8c2849', 115, '192.168.88.1', '2026-11-27 16:24:44', '2026-10-28 16:24:44');
INSERT INTO `learning_api_token` VALUES (296, '69e6c7a4575f4a0fa884f4f8084c661f', 115, '192.168.88.3', '2026-11-27 16:30:06', '2026-10-28 16:30:06');
INSERT INTO `learning_api_token` VALUES (297, 'daf193fb82ba4124a63ebecc9b9b3be1', 115, '192.168.88.3', '2026-11-27 16:49:07', '2026-10-28 16:49:07');
INSERT INTO `learning_api_token` VALUES (298, '9967b66c8bfc4ee3b7746a89990180d1', 115, '192.168.88.1', '2026-11-27 16:51:09', '2026-10-28 16:51:09');
INSERT INTO `learning_api_token` VALUES (299, '0c7aef5821024563b81cd55cd9a0617a', 115, '192.168.88.1', '2026-11-27 16:52:57', '2026-10-28 16:52:57');
INSERT INTO `learning_api_token` VALUES (300, 'c23ba66a51694c2e9eb337a6335958a1', 115, '192.168.88.1', '2026-11-27 16:53:10', '2026-10-28 16:53:10');
INSERT INTO `learning_api_token` VALUES (301, '3c07b12c7fb14fa1bb9556c1e13d489f', 115, '192.168.88.1', '2026-11-27 16:53:24', '2026-10-28 16:53:24');
INSERT INTO `learning_api_token` VALUES (302, '2ac0aa2690e64095a91260b0bb8fed1c', 115, '192.168.88.3', '2026-11-27 16:57:58', '2026-10-28 16:57:58');
INSERT INTO `learning_api_token` VALUES (303, '7ad8db041e9d4bfdb25f52b87ad85fac', 115, '192.168.88.3', '2026-11-27 16:58:48', '2026-10-28 16:58:48');
INSERT INTO `learning_api_token` VALUES (304, 'f17deb988b8b4739a29d080b7381ac4a', 115, '192.168.88.1', '2026-11-27 17:03:03', '2026-10-28 17:03:03');
INSERT INTO `learning_api_token` VALUES (305, 'dbac040d2d854de7b5b145d8f7c6225b', 111, '127.0.0.1', '2026-11-27 17:11:35', '2026-10-28 17:11:35');
INSERT INTO `learning_api_token` VALUES (306, '9bb0ea8db6af43609d1f2d2d682217e0', 111, '127.0.0.1', '2026-11-27 17:11:42', '2026-10-28 17:11:42');
INSERT INTO `learning_api_token` VALUES (307, 'fa5d91c50a0a492b97244fa1aabb0d96', 115, '192.168.88.1', '2026-11-27 17:11:48', '2026-10-28 17:11:48');
INSERT INTO `learning_api_token` VALUES (308, '874983e0485545c88ce2337a018e10fc', 112, '127.0.0.1', '2026-11-27 17:15:34', '2026-10-28 17:15:34');
INSERT INTO `learning_api_token` VALUES (309, '9da17cce5d144962a2fa4337a9d1c0c0', 111, '127.0.0.1', '2026-11-27 17:15:36', '2026-10-28 17:15:36');
INSERT INTO `learning_api_token` VALUES (310, '8eed8af8ba6640ebab62d37e14541f30', 115, '192.168.88.3', '2026-11-27 17:23:37', '2026-10-28 17:23:37');
INSERT INTO `learning_api_token` VALUES (311, 'ebf168d1800c40918fca4ce9847175eb', 111, '127.0.0.1', '2026-11-27 17:28:12', '2026-10-28 17:28:12');
INSERT INTO `learning_api_token` VALUES (312, 'f7e554696a3348b6baa09dd469d1be3b', 112, '127.0.0.1', '2026-11-27 17:34:14', '2026-10-28 17:34:14');
INSERT INTO `learning_api_token` VALUES (313, 'a45f448a42ca47449da2786cf1abe789', 112, '127.0.0.1', '2026-11-27 17:42:19', '2026-10-28 17:42:19');
INSERT INTO `learning_api_token` VALUES (314, 'e3aa2a1c37434800b312810948d21fbe', 112, '127.0.0.1', '2026-11-27 17:42:26', '2026-10-28 17:42:26');
INSERT INTO `learning_api_token` VALUES (315, '26c977d8eef6452b8bf2368fadfdf3bf', 112, '127.0.0.1', '2026-11-27 17:43:31', '2026-10-28 17:43:31');
INSERT INTO `learning_api_token` VALUES (316, '552e8ad648a44b779c12dee97bb30582', 112, '127.0.0.1', '2026-11-27 17:44:03', '2026-10-28 17:44:03');
INSERT INTO `learning_api_token` VALUES (317, '03d9f54d98064b668fe67139c500e6bf', 115, '192.168.88.3', '2026-11-27 17:54:06', '2026-10-28 17:54:06');
INSERT INTO `learning_api_token` VALUES (318, 'c7c6b4ce47ff44d28c97bfe029ef729c', 115, '192.168.88.1', '2026-11-27 19:30:23', '2026-10-28 19:30:23');
INSERT INTO `learning_api_token` VALUES (319, '4ddfaf8475df472aad78a0cd9c8d00f6', 115, '192.168.88.1', '2026-11-27 19:31:39', '2026-10-28 19:31:39');
INSERT INTO `learning_api_token` VALUES (320, '1382dddea310422f85a2062a86924fe4', 115, '192.168.88.1', '2026-11-27 19:31:57', '2026-10-28 19:31:57');
INSERT INTO `learning_api_token` VALUES (321, 'd1082ae81745482a9d2e675233217aa4', 115, '192.168.88.1', '2026-11-27 19:42:23', '2026-10-28 19:42:23');
INSERT INTO `learning_api_token` VALUES (322, '3790c2c3790c41a6a75a889f626fc85a', 115, '192.168.88.1', '2026-11-27 19:42:38', '2026-10-28 19:42:38');
INSERT INTO `learning_api_token` VALUES (323, 'a5816891ddd04761adb0e459c0f434a3', 115, '192.168.88.1', '2026-11-27 19:43:06', '2026-10-28 19:43:06');
INSERT INTO `learning_api_token` VALUES (324, '2f4e5be3c62a4510b7d16a3e0d09f945', 115, '192.168.88.1', '2026-11-27 19:51:57', '2026-10-28 19:51:57');
INSERT INTO `learning_api_token` VALUES (325, '49b45739c8b042eba8c411e44fb58a60', 115, '127.0.0.1', '2026-11-27 21:12:30', '2026-10-28 21:12:30');
INSERT INTO `learning_api_token` VALUES (326, '9552798cf4ee4e0eb935d64c0d757f25', 115, '192.168.88.3', '2026-11-27 21:13:13', '2026-10-28 21:13:13');
INSERT INTO `learning_api_token` VALUES (327, '37f56331d98e4544b978168555178879', 115, '192.168.88.3', '2026-11-27 21:25:22', '2026-10-28 21:25:22');
INSERT INTO `learning_api_token` VALUES (328, '8523ec7d06a042cf8883e0f9b1de3374', 115, '192.168.88.3', '2026-11-27 21:38:10', '2026-10-28 21:38:10');
INSERT INTO `learning_api_token` VALUES (329, '0815bfabe5394d41bb6cc5db033e5927', 115, '192.168.88.1', '2026-11-27 23:51:25', '2026-10-28 23:51:25');
INSERT INTO `learning_api_token` VALUES (330, 'f037eaa7978c4972b452d811beac0238', 119, '192.168.88.1', '2026-11-27 23:51:58', '2026-10-28 23:51:58');
INSERT INTO `learning_api_token` VALUES (331, '0a7fc11d4eb046ada2db98ce2f169f46', 115, '192.168.88.3', '2026-11-28 00:17:21', '2026-10-29 00:17:21');
INSERT INTO `learning_api_token` VALUES (332, '32f080504a084bb8b9078ee37b75daa5', 119, '192.168.88.3', '2026-11-28 00:40:19', '2026-10-29 00:40:19');
INSERT INTO `learning_api_token` VALUES (333, '49ca7aa932ea4882b154c25ad937f017', 115, '192.168.88.1', '2026-11-28 09:08:25', '2026-10-29 09:08:25');
INSERT INTO `learning_api_token` VALUES (334, 'cca1fff0320f416e8cd462d37ebb7a62', 115, '192.168.88.1', '2026-11-28 09:11:27', '2026-10-29 09:11:27');
INSERT INTO `learning_api_token` VALUES (335, '316be8c53a114d2695a9f36c98c497c5', 115, '192.168.88.1', '2026-11-28 09:15:26', '2026-10-29 09:15:26');
INSERT INTO `learning_api_token` VALUES (336, 'b4c7aa9a42f9457eb147e7220532300b', 115, '192.168.88.1', '2026-11-28 09:15:41', '2026-10-29 09:15:41');
INSERT INTO `learning_api_token` VALUES (338, '065a127ae09044fcb408f5b2121ce7c2', 118, '192.168.170.128', '2026-11-28 10:22:04', '2026-10-29 10:22:04');
INSERT INTO `learning_api_token` VALUES (339, '9f45ea64a3764160a84bb3209166bc98', 115, '192.168.88.1', '2026-11-28 10:46:04', '2026-10-29 10:46:04');
INSERT INTO `learning_api_token` VALUES (340, 'e167cb2a7c0d4dc782aee1cb9a966aeb', 115, '192.168.88.1', '2026-11-28 10:55:55', '2026-10-29 10:55:55');
INSERT INTO `learning_api_token` VALUES (341, '0096baa8816e478f96f8f68deae2f23c', 115, '192.168.88.1', '2026-11-28 10:57:50', '2026-10-29 10:57:50');
INSERT INTO `learning_api_token` VALUES (342, '1e07ddddb86e46c49e1c8f9d9ad3ded3', 115, '192.168.88.1', '2026-11-28 10:58:28', '2026-10-29 10:58:28');
INSERT INTO `learning_api_token` VALUES (343, '94ea654fde114438b8e4090ea2e9bd49', 118, '192.168.170.128', '2026-11-28 11:06:41', '2026-10-29 11:06:41');
INSERT INTO `learning_api_token` VALUES (344, '23a776b56f0047bdaec59969d2e0e4d6', 111, '127.0.0.1', '2026-11-28 11:46:17', '2026-10-29 11:46:17');
INSERT INTO `learning_api_token` VALUES (345, '3b0a14182af84569b63ea87b9a17622a', 112, '127.0.0.1', '2026-11-28 13:53:36', '2026-10-29 13:53:36');
INSERT INTO `learning_api_token` VALUES (347, 'df55163dec6948f7a4193d7ce156238d', 112, '127.0.0.1', '2026-11-28 14:02:41', '2026-10-29 14:02:41');
INSERT INTO `learning_api_token` VALUES (348, '9bc34176a52a44db8042679f1f62389b', 112, '127.0.0.1', '2026-11-28 14:11:22', '2026-10-29 14:11:22');
INSERT INTO `learning_api_token` VALUES (349, 'addd9c8d11a64efdabcc28bb22edffa7', 112, '127.0.0.1', '2026-11-28 14:11:44', '2026-10-29 14:11:44');
INSERT INTO `learning_api_token` VALUES (350, '3c979b520d3b42aaa67ed0043b2cff72', 112, '127.0.0.1', '2026-11-28 14:12:05', '2026-10-29 14:12:05');
INSERT INTO `learning_api_token` VALUES (351, 'e65997e4b5f240b09db7e4cb2f98a992', 112, '127.0.0.1', '2026-11-28 14:12:25', '2026-10-29 14:12:25');
INSERT INTO `learning_api_token` VALUES (352, '3e3d4f2052f94d02ae8b678dbffbdb81', 112, '127.0.0.1', '2026-11-28 14:12:37', '2026-10-29 14:12:37');
INSERT INTO `learning_api_token` VALUES (353, '299b62dd34ae43ed9ff53ec353a579f2', 111, '127.0.0.1', '2026-11-28 14:13:57', '2026-10-29 14:13:57');
INSERT INTO `learning_api_token` VALUES (354, '7dc3732c5d2a4a72b77b301c6ecc9847', 106, '127.0.0.1', '2026-11-28 14:14:16', '2026-10-29 14:14:16');
INSERT INTO `learning_api_token` VALUES (355, '27be81c7d630463d856e8acdf9de2482', 111, '127.0.0.1', '2026-11-28 14:14:35', '2026-10-29 14:14:35');
INSERT INTO `learning_api_token` VALUES (356, '34f6d487de31447da3dfc21ec8674b23', 111, '127.0.0.1', '2026-11-28 14:18:49', '2026-10-29 14:18:49');
INSERT INTO `learning_api_token` VALUES (357, '1cfcbb1002e44eb9977ed603c61bacb1', 112, '127.0.0.1', '2026-11-28 14:19:28', '2026-10-29 14:19:28');
INSERT INTO `learning_api_token` VALUES (358, '58ae73adc091493b8cd47516c1653239', 112, '127.0.0.1', '2026-11-28 14:23:58', '2026-10-29 14:23:58');
INSERT INTO `learning_api_token` VALUES (359, 'a45735f871ea4b9fbb3e761a4115e009', 112, '127.0.0.1', '2026-11-28 14:24:06', '2026-10-29 14:24:06');
INSERT INTO `learning_api_token` VALUES (360, '65d5c15cdd1e4f0c90a1204f61853d23', 112, '127.0.0.1', '2026-11-28 14:24:14', '2026-10-29 14:24:14');
INSERT INTO `learning_api_token` VALUES (361, '7eac5af0a3c043c6bce88fc58ce43821', 112, '127.0.0.1', '2026-11-28 14:30:30', '2026-10-29 14:30:30');
INSERT INTO `learning_api_token` VALUES (362, 'c6583d53706f489294f9e1c6157f7473', 112, '127.0.0.1', '2026-11-28 14:30:44', '2026-10-29 14:30:44');
INSERT INTO `learning_api_token` VALUES (363, '9be5fd9618f046c49621718ce8b7fb48', 112, '127.0.0.1', '2026-11-28 14:30:53', '2026-10-29 14:30:53');
INSERT INTO `learning_api_token` VALUES (364, '0b1f13a003d04efa9614bfe4f03024a4', 112, '127.0.0.1', '2026-11-28 14:35:00', '2026-10-29 14:35:00');
INSERT INTO `learning_api_token` VALUES (365, '9f5b40eaf987476e92486a565409c494', 112, '127.0.0.1', '2026-11-28 14:35:08', '2026-10-29 14:35:08');
INSERT INTO `learning_api_token` VALUES (366, '99973b9ca7d441939b93b1934d6a220d', 112, '127.0.0.1', '2026-11-28 14:35:17', '2026-10-29 14:35:17');
INSERT INTO `learning_api_token` VALUES (367, '1eda514d16c2456e8e281826ba94b7f4', 112, '127.0.0.1', '2026-11-28 14:35:44', '2026-10-29 14:35:44');
INSERT INTO `learning_api_token` VALUES (368, '727ca5e6f36a4b55865dcf68916648bf', 112, '127.0.0.1', '2026-11-28 14:35:58', '2026-10-29 14:35:58');
INSERT INTO `learning_api_token` VALUES (369, 'cef296118a204c97ae84c83e262f6a8f', 112, '127.0.0.1', '2026-11-28 14:36:40', '2026-10-29 14:36:40');
INSERT INTO `learning_api_token` VALUES (370, '24f08f2e5c604c04b86b3243f9bcbab7', 112, '127.0.0.1', '2026-11-28 14:37:36', '2026-10-29 14:37:36');
INSERT INTO `learning_api_token` VALUES (371, '4b5a83cd8f3e49d88e3eed142fc2ca74', 112, '127.0.0.1', '2026-11-28 14:37:49', '2026-10-29 14:37:49');
INSERT INTO `learning_api_token` VALUES (372, 'fd6286edf4a14589911951396c5a33cc', 112, '127.0.0.1', '2026-11-28 14:38:03', '2026-10-29 14:38:03');
INSERT INTO `learning_api_token` VALUES (373, 'd7d6edf8c082488890879e81e0bdae4c', 112, '127.0.0.1', '2026-11-28 14:38:13', '2026-10-29 14:38:13');
INSERT INTO `learning_api_token` VALUES (374, 'f257fa33b97849f5842d1170c2fb61bf', 112, '127.0.0.1', '2026-11-28 14:38:23', '2026-10-29 14:38:23');
INSERT INTO `learning_api_token` VALUES (375, 'ff20e600f81d4c33962ded8d98503b10', 112, '127.0.0.1', '2026-11-28 14:38:51', '2026-10-29 14:38:51');
INSERT INTO `learning_api_token` VALUES (376, '28ca26689ce147e4a97f3966595091ca', 112, '127.0.0.1', '2026-11-28 14:39:01', '2026-10-29 14:39:01');
INSERT INTO `learning_api_token` VALUES (377, '7f1a487d929341c88f41f4f319f197ac', 112, '127.0.0.1', '2026-11-28 14:43:01', '2026-10-29 14:43:01');
INSERT INTO `learning_api_token` VALUES (378, 'c825632ece1a45099a6a8de65a01a1da', 112, '127.0.0.1', '2026-11-28 14:43:10', '2026-10-29 14:43:10');
INSERT INTO `learning_api_token` VALUES (379, 'b1181fb8990743818efe5076c232169c', 112, '127.0.0.1', '2026-11-28 14:46:23', '2026-10-29 14:46:23');
INSERT INTO `learning_api_token` VALUES (380, '01e78df2067445d1ab787c18032ecc58', 112, '127.0.0.1', '2026-11-28 14:51:33', '2026-10-29 14:51:33');
INSERT INTO `learning_api_token` VALUES (381, 'bc8be3e696ad497187e0005efc906d28', 112, '127.0.0.1', '2026-11-28 14:58:19', '2026-10-29 14:58:19');
INSERT INTO `learning_api_token` VALUES (382, 'ed44c62688c24cd4840c9714f6abe1ec', 112, '127.0.0.1', '2026-11-28 14:59:21', '2026-10-29 14:59:21');
INSERT INTO `learning_api_token` VALUES (383, '1a08712483f844a5bf196b0f8b8d9bb0', 112, '127.0.0.1', '2026-11-28 14:59:36', '2026-10-29 14:59:36');
INSERT INTO `learning_api_token` VALUES (384, '6876abc1d0dc4c06a05327e48c38bf2b', 112, '127.0.0.1', '2026-11-28 15:06:02', '2026-10-29 15:06:02');
INSERT INTO `learning_api_token` VALUES (385, '3b009de7cec64dca8e65afde5417a946', 112, '127.0.0.1', '2026-11-28 15:14:12', '2026-10-29 15:14:12');
INSERT INTO `learning_api_token` VALUES (386, '5f4ae03ba33a4b86b3bc102035240f6a', 112, '127.0.0.1', '2026-11-28 15:14:18', '2026-10-29 15:14:18');
INSERT INTO `learning_api_token` VALUES (388, 'e575a63d5a324053a4da71cd09c7c419', 112, '127.0.0.1', '2026-11-28 15:20:37', '2026-10-29 15:20:37');
INSERT INTO `learning_api_token` VALUES (389, '9489b7345307434b848f066ef427b60e', 115, '192.168.88.3', '2026-11-28 15:35:50', '2026-10-29 15:35:50');
INSERT INTO `learning_api_token` VALUES (390, '62d0015fe49d42fc816f88c1b135b2b4', 112, '127.0.0.1', '2026-11-28 15:48:36', '2026-10-29 15:48:36');
INSERT INTO `learning_api_token` VALUES (391, '2a70452ca91e43c89b8000b64d1f9d33', 112, '127.0.0.1', '2026-11-28 16:05:40', '2026-10-29 16:05:40');
INSERT INTO `learning_api_token` VALUES (392, 'b7b80729d6094222b3a90da29016a62c', 111, '127.0.0.1', '2026-11-28 16:08:29', '2026-10-29 16:08:29');
INSERT INTO `learning_api_token` VALUES (393, '66eeadad346e4107abf82bfd9fc2c621', 115, '192.168.170.1', '2026-11-28 20:41:17', '2026-10-29 20:41:17');
INSERT INTO `learning_api_token` VALUES (395, '89eed1457a874be1b0a0285c9be0fd4a', 111, '56.10.179.194', '2026-11-29 09:50:38', '2026-10-30 09:50:38');
INSERT INTO `learning_api_token` VALUES (397, '41013d4fe46c43f2a2577de076c82e41', 111, '56.10.179.194', '2026-11-29 10:06:29', '2026-10-30 10:06:29');
INSERT INTO `learning_api_token` VALUES (398, '51386560f12a4aeeb0a12f4745fecf9c', 106, '56.10.179.194', '2026-11-29 10:06:29', '2026-10-30 10:06:29');
INSERT INTO `learning_api_token` VALUES (399, '82c89d6b98c244ac907238f1847da447', 109, '56.10.179.194', '2026-11-29 10:06:29', '2026-10-30 10:06:29');
INSERT INTO `learning_api_token` VALUES (400, '9f1cdcf9c8b740ee9b509be259407b3b', 111, '127.0.0.1', '2026-11-29 10:34:46', '2026-10-30 10:34:46');
INSERT INTO `learning_api_token` VALUES (401, 'b54b0d1ab1f64911baad122901444b25', 115, '127.0.0.1', '2026-11-29 10:39:20', '2026-10-30 10:39:20');
INSERT INTO `learning_api_token` VALUES (402, '705c9d287b584f6bbf4bb68e8d7a5a7a', 115, '127.0.0.1', '2026-11-29 12:41:13', '2026-10-30 12:41:13');
INSERT INTO `learning_api_token` VALUES (403, '5342c393dc55457f825234bafe11f480', 115, '127.0.0.1', '2026-11-29 12:41:17', '2026-10-30 12:41:17');
INSERT INTO `learning_api_token` VALUES (404, '71fdb3dcbde7466c9dc09ad96e543602', 111, '192.168.170.129', '2026-11-29 15:26:18', '2026-10-30 15:26:18');
INSERT INTO `learning_api_token` VALUES (406, 'eb65b1a3207848a58f8c015aa3756813', 111, '127.0.0.1', '2026-12-02 09:29:15', '2026-11-02 09:29:15');
INSERT INTO `learning_api_token` VALUES (407, 'acbc08d0123d40a7912f7ecab4e22cb8', 111, '127.0.0.1', '2026-12-02 09:30:34', '2026-11-02 09:30:34');
INSERT INTO `learning_api_token` VALUES (408, '62da9e140a254491b0a57a53024af94b', 111, '127.0.0.1', '2026-12-02 09:37:55', '2026-11-02 09:37:55');
INSERT INTO `learning_api_token` VALUES (409, '47b2f543f34747b0a3328c1e581ed909', 111, '127.0.0.1', '2026-12-02 09:38:19', '2026-11-02 09:38:19');
INSERT INTO `learning_api_token` VALUES (410, '8f0891940f8b4fe8a95b4bcfc1f33c6e', 106, '127.0.0.1', '2026-12-02 09:42:28', '2026-11-02 09:42:28');
INSERT INTO `learning_api_token` VALUES (411, '056b566bbdbc4a22b6f18fe3f62f6e05', 111, '127.0.0.1', '2026-12-02 09:42:29', '2026-11-02 09:42:29');
INSERT INTO `learning_api_token` VALUES (412, '50e1090c39254dde9cb2d974feeb81a5', 106, '127.0.0.1', '2026-12-02 09:45:48', '2026-11-02 09:45:48');
INSERT INTO `learning_api_token` VALUES (413, '17c6cf77d3c94e469b28af8e9fc86aac', 111, '127.0.0.1', '2026-12-02 09:45:49', '2026-11-02 09:45:49');
INSERT INTO `learning_api_token` VALUES (414, '66849c6eb8ac406ebbbc8cd3b464e2de', 106, '127.0.0.1', '2026-12-02 09:47:10', '2026-11-02 09:47:10');
INSERT INTO `learning_api_token` VALUES (415, '40669ffbfa764fafb79b492bbfd920c7', 106, '127.0.0.1', '2026-12-02 09:47:29', '2026-11-02 09:47:29');
INSERT INTO `learning_api_token` VALUES (416, '114c390df9db4d2c8a5acc6c3cf0298c', 111, '127.0.0.1', '2026-12-02 09:51:55', '2026-11-02 09:51:55');
INSERT INTO `learning_api_token` VALUES (417, 'ea99f397373c49029508e32426330c18', 106, '127.0.0.1', '2026-12-02 09:52:06', '2026-11-02 09:52:06');
INSERT INTO `learning_api_token` VALUES (418, 'cd40c2e9af154f74a252b98078bc5084', 112, '127.0.0.1', '2026-12-02 09:52:04', '2026-11-02 09:52:04');
INSERT INTO `learning_api_token` VALUES (419, 'b22f8dcf85c049fd914d23dcb50b0306', 111, '127.0.0.1', '2026-12-02 09:52:08', '2026-11-02 09:52:08');
INSERT INTO `learning_api_token` VALUES (420, '73a9bb7278524f479ddf130e5eee825b', 111, '127.0.0.1', '2026-12-02 10:01:30', '2026-11-02 10:01:30');
INSERT INTO `learning_api_token` VALUES (421, '8c3873be86e94114aa03f337af433892', 111, '18.140.50.255', '2026-12-02 10:38:02', '2026-11-02 10:38:02');
INSERT INTO `learning_api_token` VALUES (422, 'c0c9526316d44c329f6eb294d293af6e', 106, '18.140.50.255', '2026-12-02 10:38:03', '2026-11-02 10:38:03');
INSERT INTO `learning_api_token` VALUES (423, '748ed9446fe54bc5b8bb1c868849a591', 111, '18.140.50.255', '2026-12-02 10:38:05', '2026-11-02 10:38:05');
INSERT INTO `learning_api_token` VALUES (424, '492a84a8d5d34b71bc3ab36e2b98bf28', 111, '18.140.50.255', '2026-12-02 10:53:18', '2026-11-02 10:53:18');
INSERT INTO `learning_api_token` VALUES (425, '019b70ee7f794956bae2f8791dce693c', 106, '18.140.50.255', '2026-12-02 10:53:18', '2026-11-02 10:53:18');
INSERT INTO `learning_api_token` VALUES (426, 'fbe36da5c8064119a87d85fe97426c53', 111, '18.140.50.255', '2026-12-02 10:53:19', '2026-11-02 10:53:19');
INSERT INTO `learning_api_token` VALUES (427, '8aa9ceec6e1a400fac75fa7acbb5512a', 111, '18.140.50.255', '2026-12-02 10:56:26', '2026-11-02 10:56:26');
INSERT INTO `learning_api_token` VALUES (428, '571a88c961b241f596ae5cd40abe172c', 115, '192.168.88.1', '2026-12-02 14:52:28', '2026-11-02 14:52:28');
INSERT INTO `learning_api_token` VALUES (429, '87fba1e1037f4051b30a546731fc99cc', 112, '127.0.0.1', '2026-12-02 15:42:17', '2026-11-02 15:42:17');
INSERT INTO `learning_api_token` VALUES (430, 'e26c88d384a94362a6443ea822e4b386', 111, '127.0.0.1', '2026-12-02 15:49:32', '2026-11-02 15:49:32');
INSERT INTO `learning_api_token` VALUES (431, 'fdb66406bbb5425e905790894af3e3e2', 111, '127.0.0.1', '2026-12-02 15:49:47', '2026-11-02 15:49:47');
INSERT INTO `learning_api_token` VALUES (432, '7b7ed6057c614dd5ae3cb1b22b8029ed', 111, '127.0.0.1', '2026-12-02 15:50:53', '2026-11-02 15:50:53');
INSERT INTO `learning_api_token` VALUES (433, '441bee919c0649cf9e5cd23f064570d6', 111, '127.0.0.1', '2026-12-02 16:19:00', '2026-11-02 16:19:00');
INSERT INTO `learning_api_token` VALUES (434, 'ead8e394cb73471187910a68edde6195', 111, '127.0.0.1', '2026-12-02 16:28:15', '2026-11-02 16:28:15');
INSERT INTO `learning_api_token` VALUES (435, 'f7e75b74077a4fe3995441c7a5f533d9', 115, '127.0.0.1', '2026-12-04 09:54:43', '2026-11-04 09:54:43');
INSERT INTO `learning_api_token` VALUES (436, '4930706016a74d31a1d4866e7ebdd5f8', 115, '127.0.0.1', '2026-12-04 17:11:41', '2026-11-04 17:11:41');
INSERT INTO `learning_api_token` VALUES (437, '9a27c15ac0ef4710894b0bee5fb9cb30', 115, '127.0.0.1', '2026-12-04 17:11:41', '2026-11-04 17:11:41');
INSERT INTO `learning_api_token` VALUES (438, 'e550dbddac4a4fc1989a4085e5e0b777', 115, '127.0.0.1', '2026-12-04 17:28:05', '2026-11-04 17:28:05');
INSERT INTO `learning_api_token` VALUES (439, '6dab49667396449b83b50a48eb02e458', 115, '127.0.0.1', '2026-12-04 17:32:26', '2026-11-04 17:32:26');
INSERT INTO `learning_api_token` VALUES (440, 'a22adc7a92c040b5b62b5df99ff4ea75', 115, '127.0.0.1', '2026-12-04 17:33:30', '2026-11-04 17:33:30');
INSERT INTO `learning_api_token` VALUES (441, '53c11820c89644a29a34d820de1ca36a', 115, '127.0.0.1', '2026-12-04 17:34:16', '2026-11-04 17:34:16');
INSERT INTO `learning_api_token` VALUES (442, 'd1bb7b6594c946a38f721f97d7475693', 115, '127.0.0.1', '2026-12-04 17:34:44', '2026-11-04 17:34:44');
INSERT INTO `learning_api_token` VALUES (443, 'ed81fbe690e94f08b2d5b1f3e98cb4df', 115, '127.0.0.1', '2026-12-05 09:50:11', '2026-11-05 09:50:11');
INSERT INTO `learning_api_token` VALUES (444, 'ef6128a84d2143b292bbb27ce48c670b', 115, '127.0.0.1', '2026-12-05 09:50:27', '2026-11-05 09:50:27');
INSERT INTO `learning_api_token` VALUES (445, '11c815980c0843ce8ea9f108fabf319c', 115, '127.0.0.1', '2026-12-05 10:13:11', '2026-11-05 10:13:11');
INSERT INTO `learning_api_token` VALUES (446, 'd0a7d46032044dd6a6b63821106e6183', 115, '58.16.41.98', '2026-12-05 14:04:28', '2026-11-05 14:04:28');
INSERT INTO `learning_api_token` VALUES (447, '3c5e5088faec4a2ea664389f48904123', 115, '58.16.41.98', '2026-12-05 14:04:35', '2026-11-05 14:04:35');
INSERT INTO `learning_api_token` VALUES (448, '10de778aca7f49ef91ded5e32292575f', 115, '58.16.41.98', '2026-12-05 14:04:36', '2026-11-05 14:04:36');
INSERT INTO `learning_api_token` VALUES (449, '1dbe49e195b8418398baa274187c5371', 115, '58.16.41.98', '2026-12-05 14:04:44', '2026-11-05 14:04:44');
INSERT INTO `learning_api_token` VALUES (450, '6dd2171dbae04804917dd29b6d12d4fc', 115, '58.16.41.98', '2026-12-05 14:20:47', '2026-11-05 14:20:47');
INSERT INTO `learning_api_token` VALUES (451, '3d4ebb58204542ff8990f14b9dec531f', 115, '127.0.0.1', '2026-12-05 14:44:45', '2026-11-05 14:44:45');
INSERT INTO `learning_api_token` VALUES (452, 'bdb1dfabd93b47f3b9dc489a3850f791', 115, '127.0.0.1', '2026-12-05 15:39:58', '2026-11-05 15:39:58');
INSERT INTO `learning_api_token` VALUES (453, '37f376d19bae4367997dfea4bcb8ba87', 115, '127.0.0.1', '2026-12-05 16:04:50', '2026-11-05 16:04:50');
INSERT INTO `learning_api_token` VALUES (454, '7362ebb0d966465e81b0a0dd351755fd', 115, '127.0.0.1', '2026-12-05 16:28:16', '2026-11-05 16:28:16');
INSERT INTO `learning_api_token` VALUES (455, 'd4a2b03f40cc484fae6c8a22b014fdd5', 115, '127.0.0.1', '2026-12-05 16:28:40', '2026-11-05 16:28:40');
INSERT INTO `learning_api_token` VALUES (456, 'e77e7864f2394a65bcb8552e7353a416', 115, '127.0.0.1', '2026-12-05 16:29:14', '2026-11-05 16:29:14');
INSERT INTO `learning_api_token` VALUES (457, 'a603a2a703664bb7a0effffb3c5ed47f', 115, '127.0.0.1', '2026-12-05 16:30:01', '2026-11-05 16:30:01');
INSERT INTO `learning_api_token` VALUES (458, '7fa2b07c45cd41709b5957cae76348bf', 115, '127.0.0.1', '2026-12-05 16:30:13', '2026-11-05 16:30:13');
INSERT INTO `learning_api_token` VALUES (459, '81526d72a239449b992e47fa8c0ec8e5', 115, '127.0.0.1', '2026-12-05 16:30:35', '2026-11-05 16:30:35');
INSERT INTO `learning_api_token` VALUES (461, '98e6adc0743f48988bb01bd5118309ab', 111, '192.168.88.1', '2026-12-06 09:56:21', '2026-11-06 09:56:21');
INSERT INTO `learning_api_token` VALUES (464, 'faea8d7f06a5471cae3f4ff652b4c3fb', 115, '127.0.0.1', '2026-12-06 14:53:01', '2026-11-06 14:53:01');
INSERT INTO `learning_api_token` VALUES (465, '6c039d813019456381a662689b39c84f', 115, '127.0.0.1', '2026-12-06 14:53:10', '2026-11-06 14:53:10');
INSERT INTO `learning_api_token` VALUES (466, '57579fae94644184bf1e72a76bac2367', 115, '127.0.0.1', '2026-12-06 14:53:18', '2026-11-06 14:53:18');
INSERT INTO `learning_api_token` VALUES (469, 'ee15087c4e3541d5983d847b0c6ed556', 115, '192.168.88.3', '2026-12-06 16:58:46', '2026-11-06 16:58:46');
INSERT INTO `learning_api_token` VALUES (470, '4048807a6e5947a9b6c657794a2fa05e', 115, '192.168.88.3', '2026-12-06 16:59:07', '2026-11-06 16:59:07');
INSERT INTO `learning_api_token` VALUES (471, '8a8a0c23baf84733941064b9ab6657b3', 115, '192.168.88.3', '2026-12-06 16:59:32', '2026-11-06 16:59:32');
INSERT INTO `learning_api_token` VALUES (473, 'e21dbb1f82a5432b984d5f6d1e5f4c18', 112, '127.0.0.1', '2026-12-09 09:02:32', '2026-11-09 09:02:32');
INSERT INTO `learning_api_token` VALUES (474, '959026633f5a45adba9a5170f9abb5c2', 115, '192.168.88.3', '2026-12-09 09:15:42', '2026-11-09 09:15:42');
INSERT INTO `learning_api_token` VALUES (475, 'e450610e187f42d5a3f8c35241475327', 115, '192.168.88.3', '2026-12-09 09:18:59', '2026-11-09 09:18:59');
INSERT INTO `learning_api_token` VALUES (476, '1175ee4b91ff448cb9405670dc732f1f', 115, '192.168.88.3', '2026-12-09 09:23:05', '2026-11-09 09:23:05');
INSERT INTO `learning_api_token` VALUES (477, '71933b5cf0024d06b4889b6d5239701c', 115, '192.168.88.3', '2026-12-09 09:23:19', '2026-11-09 09:23:19');
INSERT INTO `learning_api_token` VALUES (478, '1ea390b7d3724c41bf98737eec527f90', 115, '192.168.88.1', '2026-12-09 10:59:39', '2026-11-09 10:59:39');
INSERT INTO `learning_api_token` VALUES (479, '730ae9a0fbea4c22a1a6f39aae1a3640', 119, '192.168.88.1', '2026-12-09 10:59:40', '2026-11-09 10:59:40');
INSERT INTO `learning_api_token` VALUES (481, 'a286abd8db734f408689f6cf73b0282f', 115, '127.0.0.1', '2026-12-09 11:10:37', '2026-11-09 11:10:37');
INSERT INTO `learning_api_token` VALUES (482, '60759e23e9734feda921e2b995d47195', 115, '127.0.0.1', '2026-12-09 11:10:44', '2026-11-09 11:10:44');
INSERT INTO `learning_api_token` VALUES (483, '10ac737e3cfe4c898adca87d2fadacc2', 115, '127.0.0.1', '2026-12-09 11:10:55', '2026-11-09 11:10:55');
INSERT INTO `learning_api_token` VALUES (484, '9575a61107064193956618d66c95b7a1', 111, '127.0.0.1', '2026-12-10 09:39:41', '2026-11-10 09:39:41');
INSERT INTO `learning_api_token` VALUES (485, '8e01fcab7e604b2db981abd85c98e6fd', 111, '127.0.0.1', '2026-12-10 09:40:07', '2026-11-10 09:40:07');
INSERT INTO `learning_api_token` VALUES (486, 'f852161f65404f52b6275e87bcb72f88', 111, '127.0.0.1', '2026-12-10 15:51:00', '2026-11-10 15:51:00');
INSERT INTO `learning_api_token` VALUES (487, 'ae5077e681b1485ca08072a5da37a994', 111, '127.0.0.1', '2026-12-10 15:54:47', '2026-11-10 15:54:47');
INSERT INTO `learning_api_token` VALUES (489, 'daf8c090099c46bfaf2dc5942ff0b9a4', 118, '127.0.0.1', '2026-12-11 10:30:54', '2026-11-11 10:30:54');
INSERT INTO `learning_api_token` VALUES (490, '7d642074073a4199929d7fd1ed77c306', 118, '127.0.0.1', '2026-12-11 10:32:25', '2026-11-11 10:32:25');
INSERT INTO `learning_api_token` VALUES (491, '201fb8d9634e43c5ae72290a5a3f8037', 118, '127.0.0.1', '2026-12-11 10:32:39', '2026-11-11 10:32:39');
INSERT INTO `learning_api_token` VALUES (492, '4f4b0bfa62414fb89ebc0fd41e1fde4c', 111, '127.0.0.1', '2026-12-11 11:04:04', '2026-11-11 11:04:04');
INSERT INTO `learning_api_token` VALUES (493, 'e98e5be4cd9e48ffaaf56d79051bd87e', 115, '127.0.0.1', '2026-12-11 14:04:45', '2026-11-11 14:04:45');
INSERT INTO `learning_api_token` VALUES (494, '39a5355974294ceca0eb32ba1b2203f7', 115, '127.0.0.1', '2026-12-11 14:04:49', '2026-11-11 14:04:49');
INSERT INTO `learning_api_token` VALUES (495, 'e4ba6a4462fa4764ae910df94271ecc4', 115, '127.0.0.1', '2026-12-11 14:07:18', '2026-11-11 14:07:18');
INSERT INTO `learning_api_token` VALUES (496, '8676b3edf03e4dd19e26a2a85400ee07', 115, '127.0.0.1', '2026-12-11 14:08:00', '2026-11-11 14:08:00');
INSERT INTO `learning_api_token` VALUES (497, 'eb08c2af74f449c4b179051079e66cce', 115, '127.0.0.1', '2026-12-11 15:31:40', '2026-11-11 15:31:40');
INSERT INTO `learning_api_token` VALUES (498, 'c43ef36847d44567a1d342ef4def72f3', 115, '127.0.0.1', '2026-12-11 15:33:09', '2026-11-11 15:33:09');
INSERT INTO `learning_api_token` VALUES (499, '064d4ad40564433399b5899c7b2fd775', 115, '127.0.0.1', '2026-12-11 15:39:38', '2026-11-11 15:39:38');
INSERT INTO `learning_api_token` VALUES (500, 'b955362391a5453b9aa21ba7813d90de', 115, '127.0.0.1', '2026-12-11 15:44:31', '2026-11-11 15:44:31');
INSERT INTO `learning_api_token` VALUES (501, '3dfdd714d7d44bcf9ef919ee334d7c7d', 115, '127.0.0.1', '2026-12-11 15:53:50', '2026-11-11 15:53:50');
INSERT INTO `learning_api_token` VALUES (502, 'f0bacc2e41364c1e81aa607dbc91f047', 115, '127.0.0.1', '2026-12-11 15:57:32', '2026-11-11 15:57:32');
INSERT INTO `learning_api_token` VALUES (503, '5f5e4be73a334191aec210624ba7af78', 115, '192.168.101.194', '2026-12-11 17:18:03', '2026-11-11 17:18:03');
INSERT INTO `learning_api_token` VALUES (504, '15834f3f5ee7456b8906fd58216f4954', 121, '58.16.41.98', '2026-12-12 14:42:30', '2026-11-12 14:42:30');
INSERT INTO `learning_api_token` VALUES (505, '116f3b8b4fa24d359cb9abe66d2e46e2', 121, '58.16.41.98', '2026-12-12 14:43:16', '2026-11-12 14:43:16');
INSERT INTO `learning_api_token` VALUES (506, '90fdc108050c4e35bbc4b5e67aa4cbf4', 121, '58.16.41.98', '2026-12-12 14:43:50', '2026-11-12 14:43:50');
INSERT INTO `learning_api_token` VALUES (507, '4cad2a0ad8684756865a0d873190029a', 121, '58.16.41.98', '2026-12-12 14:44:05', '2026-11-12 14:44:05');
INSERT INTO `learning_api_token` VALUES (508, 'bfddcd34b46f4eada0e883812f160df8', 111, '127.0.0.1', '2026-12-13 10:59:38', '2026-11-13 10:59:38');
INSERT INTO `learning_api_token` VALUES (509, 'd07ef1f5c0f841aa867856cb6e805428', 112, '127.0.0.1', '2026-12-13 18:11:59', '2026-11-13 18:11:59');
INSERT INTO `learning_api_token` VALUES (510, '4fa9d7a966174fba936d8d242959b9d1', 112, '127.0.0.1', '2026-12-13 18:33:00', '2026-11-13 18:33:00');
INSERT INTO `learning_api_token` VALUES (511, '1d823244a11842a4b475606fba1e5d4c', 122, '127.0.0.1', '2026-12-16 09:06:41', '2026-11-16 09:06:41');
INSERT INTO `learning_api_token` VALUES (512, '2ce559ab80844dfabc2545f21f2b000b', 122, '127.0.0.1', '2026-12-16 09:06:55', '2026-11-16 09:06:55');
INSERT INTO `learning_api_token` VALUES (513, '263baa98c3224a6283b9fa6555f66836', 122, '127.0.0.1', '2026-12-16 09:10:23', '2026-11-16 09:10:23');
INSERT INTO `learning_api_token` VALUES (514, '32b8296a368e425e980142fb00dc6e02', 111, '192.168.101.121', '2026-12-17 09:07:00', '2026-11-17 09:07:00');
INSERT INTO `learning_api_token` VALUES (516, 'aafc1ea82734491a98b61cb38f41f3eb', 111, '127.0.0.1', '2026-12-17 09:16:24', '2026-11-17 09:16:24');
INSERT INTO `learning_api_token` VALUES (517, '039a3e287ba24e4eadceea71dd93e149', 111, '127.0.0.1', '2026-12-17 14:18:19', '2026-11-17 14:18:19');
INSERT INTO `learning_api_token` VALUES (521, 'f52aa416c1874dd7810f1cefc2030560', 112, '127.0.0.1', '2026-12-17 14:56:02', '2026-11-17 14:56:02');
INSERT INTO `learning_api_token` VALUES (522, 'd698e6f7d5eb40ea9b8a8ee295344629', 125, '127.0.0.1', '2026-12-17 15:07:23', '2026-11-17 15:07:23');
INSERT INTO `learning_api_token` VALUES (523, '473b04f1fb064f44b4df016c381d0985', 126, '127.0.0.1', '2026-12-17 15:09:41', '2026-11-17 15:09:41');
INSERT INTO `learning_api_token` VALUES (524, 'e6f005725dd045358b602f73201d8e6a', 125, '127.0.0.1', '2026-12-17 15:10:14', '2026-11-17 15:10:14');
INSERT INTO `learning_api_token` VALUES (525, '16ca2c1e8fae41b1839ff728190c46d4', 125, '127.0.0.1', '2026-12-17 15:11:08', '2026-11-17 15:11:08');
INSERT INTO `learning_api_token` VALUES (527, 'c8da20f520204272b30c90961a8104eb', 125, '127.0.0.1', '2026-12-17 15:19:18', '2026-11-17 15:19:18');
INSERT INTO `learning_api_token` VALUES (528, 'dd4742c850c745df8cb8e1fe5d760cff', 125, '127.0.0.1', '2026-12-17 15:21:41', '2026-11-17 15:21:41');
INSERT INTO `learning_api_token` VALUES (533, '582ebc49b2ae4ab6ab436301477ef33f', 112, '127.0.0.1', '2026-12-17 15:51:10', '2026-11-17 15:51:10');
INSERT INTO `learning_api_token` VALUES (534, '90c03c6b8a5a4645b7ebe3702f34aa93', 111, '192.168.101.121', '2026-12-17 16:12:48', '2026-11-17 16:12:48');
INSERT INTO `learning_api_token` VALUES (535, '6c927f20429845edbfb652fe2c05ac1f', 112, '127.0.0.1', '2026-12-17 16:55:05', '2026-11-17 16:55:05');
INSERT INTO `learning_api_token` VALUES (536, 'f61df9301806494e9df0c6113bfb3aec', 112, '127.0.0.1', '2026-12-17 16:58:41', '2026-11-17 16:58:41');
INSERT INTO `learning_api_token` VALUES (537, '62235c76e06a4a7ba48dfe781feb20d0', 115, '127.0.0.1', '2026-12-17 21:09:31', '2026-11-17 21:09:31');
INSERT INTO `learning_api_token` VALUES (538, 'bf7e04a7f3684545a65316d54f43c910', 115, '127.0.0.1', '2026-12-17 21:09:36', '2026-11-17 21:09:36');
INSERT INTO `learning_api_token` VALUES (539, '6982b59b77db4b56b107bbf9564d4cdb', 115, '127.0.0.1', '2026-12-17 21:09:37', '2026-11-17 21:09:37');
INSERT INTO `learning_api_token` VALUES (540, '719e88aa91ae4d2bb70fa8da684f807f', 115, '127.0.0.1', '2026-12-17 21:09:44', '2026-11-17 21:09:44');
INSERT INTO `learning_api_token` VALUES (541, 'dc571cb3a5834b1594911200069f062f', 115, '127.0.0.1', '2026-12-18 10:24:37', '2026-11-18 10:24:37');
INSERT INTO `learning_api_token` VALUES (542, '69f984edf83447fd95007416ed25226d', 115, '127.0.0.1', '2026-12-18 10:24:50', '2026-11-18 10:24:50');
INSERT INTO `learning_api_token` VALUES (543, 'b679b0730fe841878710d9d11e3edf84', 118, '127.0.0.1', '2026-12-18 11:13:57', '2026-11-18 11:13:57');
INSERT INTO `learning_api_token` VALUES (544, '453ceedcd8d3469bbba7f2a9b78139b0', 111, '127.0.0.1', '2026-12-18 11:13:59', '2026-11-18 11:13:59');
INSERT INTO `learning_api_token` VALUES (545, 'f971af60508d4d6da0d34303a7b09bf6', 118, '127.0.0.1', '2026-12-18 11:14:51', '2026-11-18 11:14:51');
INSERT INTO `learning_api_token` VALUES (546, '7801c40de20e4dfa98de90dd059dd41a', 111, '127.0.0.1', '2026-12-18 11:14:53', '2026-11-18 11:14:53');
INSERT INTO `learning_api_token` VALUES (547, '8237e8608ba346dfb82b6171b1aa3594', 111, '127.0.0.1', '2026-12-18 11:15:58', '2026-11-18 11:15:58');
INSERT INTO `learning_api_token` VALUES (548, '4d9b0f6b4ee144cfbfe457f4c1db7c6b', 122, '58.16.41.98', '2026-12-18 11:37:21', '2026-11-18 11:37:21');
INSERT INTO `learning_api_token` VALUES (549, '93d4ff3fc76c4cb9848cf78ad894301e', 118, '127.0.0.1', '2026-12-18 11:48:18', '2026-11-18 11:48:18');
INSERT INTO `learning_api_token` VALUES (550, '7f4169a1a4e448e8a9c38b013bfbc224', 118, '127.0.0.1', '2026-12-18 11:48:30', '2026-11-18 11:48:30');
INSERT INTO `learning_api_token` VALUES (551, '7ffa10fe011a466bbe13748f53f0912a', 115, '127.0.0.1', '2026-12-18 14:11:04', '2026-11-18 14:11:04');
INSERT INTO `learning_api_token` VALUES (552, 'b151a2da5988408b97ccc637f27d365b', 112, '127.0.0.1', '2026-12-18 15:17:48', '2026-11-18 15:17:48');
INSERT INTO `learning_api_token` VALUES (553, '139770b94e6a4900925f86b73654d67b', 112, '127.0.0.1', '2026-12-18 15:17:58', '2026-11-18 15:17:58');
INSERT INTO `learning_api_token` VALUES (554, 'd255d9a3e90c442c8543633c46dce0a6', 112, '127.0.0.1', '2026-12-18 15:18:08', '2026-11-18 15:18:08');
INSERT INTO `learning_api_token` VALUES (555, '1a585ac0ad3446ab89b7115f2d4bf33f', 112, '127.0.0.1', '2026-12-18 15:35:56', '2026-11-18 15:35:56');
INSERT INTO `learning_api_token` VALUES (556, '84fbc78791fd46aca95101b4f6edd429', 112, '127.0.0.1', '2026-12-18 15:53:26', '2026-11-18 15:53:26');
INSERT INTO `learning_api_token` VALUES (557, 'b553600e756b44748d396bb714b27150', 112, '127.0.0.1', '2026-12-18 15:53:44', '2026-11-18 15:53:44');
INSERT INTO `learning_api_token` VALUES (558, 'dfe4ed2f4632496ba9b48ce6e9c6863f', 112, '127.0.0.1', '2026-12-18 15:54:02', '2026-11-18 15:54:02');
INSERT INTO `learning_api_token` VALUES (559, 'b1f4d70597c445c8889401e565beaa7a', 112, '127.0.0.1', '2026-12-18 15:54:17', '2026-11-18 15:54:17');
INSERT INTO `learning_api_token` VALUES (560, 'fb150fd01a4846328a39d4e0f1d2d4c9', 112, '127.0.0.1', '2026-12-18 15:55:08', '2026-11-18 15:55:08');
INSERT INTO `learning_api_token` VALUES (561, '14d889393f1b4c4e81f0af4ee166a5c8', 112, '127.0.0.1', '2026-12-18 15:55:21', '2026-11-18 15:55:21');
INSERT INTO `learning_api_token` VALUES (562, '7d7e36e1d8364168a312f1ec27a296c1', 112, '127.0.0.1', '2026-12-18 15:55:34', '2026-11-18 15:55:34');
INSERT INTO `learning_api_token` VALUES (563, '181bdd05c5a6463982b7097b92f6c8a8', 112, '220.197.4.230', '2026-12-18 15:59:36', '2026-11-18 15:59:36');
INSERT INTO `learning_api_token` VALUES (564, 'ec7a34a8a2174435b23cd6373321240b', 128, '114.138.157.27', '2026-12-18 16:09:38', '2026-11-18 16:09:38');
INSERT INTO `learning_api_token` VALUES (565, 'c59c3946c48f4a769507525dba154f61', 112, '114.139.112.68', '2026-12-18 16:14:16', '2026-11-18 16:14:16');
INSERT INTO `learning_api_token` VALUES (566, '03695c37cee44e36bfbd6850a372021f', 112, '127.0.0.1', '2026-12-18 16:19:19', '2026-11-18 16:19:19');
INSERT INTO `learning_api_token` VALUES (567, 'c2ccc13ef45e4766927387ab1dde6fd5', 112, '114.139.112.68', '2026-12-18 16:21:01', '2026-11-18 16:21:01');
INSERT INTO `learning_api_token` VALUES (569, '284bdb2fdd6d4d2894526d3d19531b6d', 111, '39.144.231.36', '2026-12-18 16:27:18', '2026-11-18 16:27:18');
INSERT INTO `learning_api_token` VALUES (570, 'dc20e2600e084c7994212747124db3cd', 112, '127.0.0.1', '2026-12-18 16:39:56', '2026-11-18 16:39:56');

-- ----------------------------
-- Table structure for learning_banner
-- ----------------------------
DROP TABLE IF EXISTS `learning_banner`;
CREATE TABLE `learning_banner`  (
  `banner_id` bigint NOT NULL AUTO_INCREMENT COMMENT '轮播图ID',
  `category_id` bigint NOT NULL DEFAULT 0 COMMENT '所属类别ID（0=全部；其余逻辑关联 learning_category.category_id）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '轮播标题',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '轮播图片地址（上传返回的相对路径 /profile/...，OSS 开启时为完整 URL）',
  `course_id` bigint NOT NULL COMMENT '点击跳转的课程ID（逻辑关联 learning_course.course_id）',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`banner_id`) USING BTREE,
  INDEX `idx_banner_category`(`category_id` ASC, `del_flag` ASC, `status` ASC, `order_num` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 315 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台课程轮播图表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_banner
-- ----------------------------
INSERT INTO `learning_banner` VALUES (301, 0, '首页轮播A', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/3_20261027210506A004.jpg', 201, 1, '0', '2', 'admin', '2026-10-21 09:39:54', 'admin', '2026-10-30 17:13:35', '轮播图测试数据');
INSERT INTO `learning_banner` VALUES (302, 0, '首页轮播B', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/2_20261027210518A005.jpg', 202, 2, '0', '2', 'admin', '2026-10-21 09:39:54', 'admin', '2026-10-30 17:13:47', '轮播图测试数据');
INSERT INTO `learning_banner` VALUES (303, 101, 'Java课程推荐', '/profile/upload/2026/10/26/1_20261026215112A008.jpg', 201, 1, '0', '2', 'admin', '2026-10-21 09:39:54', 'admin', '2026-10-30 17:13:38', '轮播图测试数据');
INSERT INTO `learning_banner` VALUES (304, 103, 'MySQL课程推荐', '/profile/upload/2026/10/26/2_20261026215058A007.jpg', 202, 1, '0', '2', 'admin', '2026-10-21 09:39:54', 'admin', '2026-10-30 17:13:41', '轮播图测试数据');
INSERT INTO `learning_banner` VALUES (305, 105, 'Redis课程推荐', '/profile/upload/banner-redis.jpg', 203, 1, '0', '2', 'admin', '2026-10-21 09:39:54', '', '2026-10-30 17:13:44', '轮播图测试数据');
INSERT INTO `learning_banner` VALUES (306, 0, '停用轮播', '/profile/upload/banner-stop.jpg', 203, 3, '1', '2', 'admin', '2026-10-21 09:39:54', '', '2026-10-30 17:10:43', '轮播图测试数据-应不显示');
INSERT INTO `learning_banner` VALUES (307, 101, '指向已删课程', '/profile/upload/banner-del.jpg', 100, 2, '0', '2', 'admin', '2026-10-21 09:39:54', '', '2026-10-30 17:10:46', '轮播图测试数据-应静默消失');
INSERT INTO `learning_banner` VALUES (308, 101, '指向停用课程', '/profile/upload/banner-stop2.jpg', 105, 3, '0', '2', 'admin', '2026-10-21 09:39:54', '', '2026-10-30 17:10:39', '轮播图测试数据-应静默消失');
INSERT INTO `learning_banner` VALUES (309, 0, '孤儿分类窗口', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/1_20261027210545A006.jpg', 201, 4, '0', '2', 'admin', '2026-10-21 09:39:54', 'admin', '2026-10-30 17:10:00', '轮播图测试数据');
INSERT INTO `learning_banner` VALUES (311, 0, '测试修改轮播', '/x2.jpg', 202, 6, '0', '2', 'admin', '2026-10-21 10:12:20', 'admin', '2026-10-21 10:12:21', NULL);
INSERT INTO `learning_banner` VALUES (312, 0, 'Java-从入门到实战', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/1-Java-从入门到实战_20261030171438A018.jpg', 201, 1, '0', '0', 'admin', '2026-10-30 17:14:58', 'admin', '2026-10-30 17:26:19', '');
INSERT INTO `learning_banner` VALUES (313, 0, 'MySQL-性能优化实战', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/2-MySQL-性能优化实战_20261030171534A019.jpg', 202, 2, '0', '0', 'admin', '2026-10-30 17:15:43', 'admin', '2026-10-30 17:26:26', '');
INSERT INTO `learning_banner` VALUES (314, 0, 'Redis-缓存原理与实战', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/3-Redis-缓存原理与实战_20261030171602A020.jpg', 203, 3, '0', '0', 'admin', '2026-10-30 17:16:11', 'admin', '2026-10-30 17:26:37', '');

-- ----------------------------
-- Table structure for learning_category
-- ----------------------------
DROP TABLE IF EXISTS `learning_category`;
CREATE TABLE `learning_category`  (
  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT '类别ID',
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类别名称',
  `category_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类别类型（course课程 article社区文章）',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`category_id`) USING BTREE,
  INDEX `idx_category_type`(`category_type` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 132 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台类别表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_category
-- ----------------------------
INSERT INTO `learning_category` VALUES (100, 'java', 'article', 1, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (101, 'java', 'course', 1, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (102, 'mysql', 'article', 2, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (103, 'mysql', 'course', 2, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (104, 'redis', 'article', 3, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (105, 'redis', 'course', 3, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (106, 'kafka', 'article', 4, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (107, 'kafka', 'course', 4, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (108, '计算机网络', 'article', 5, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (109, '计算机网络', 'course', 5, '0', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '类别初始化数据');
INSERT INTO `learning_category` VALUES (129, '测试分类A改', 'course', 99, '0', '2', 'admin', '2026-10-13 17:56:40', 'admin', '2026-10-13 18:00:49', NULL);
INSERT INTO `learning_category` VALUES (130, '越权测试', 'course', 99, '0', '2', '13900001111', '2026-10-14 09:16:23', '', '2026-10-14 09:29:51', NULL);
INSERT INTO `learning_category` VALUES (131, '越权回归', 'course', 99, '0', '2', '13900001111', '2026-10-14 10:50:21', '', '2026-10-14 10:54:09', NULL);

-- ----------------------------
-- Table structure for learning_checkin
-- ----------------------------
DROP TABLE IF EXISTS `learning_checkin`;
CREATE TABLE `learning_checkin`  (
  `checkin_id` bigint NOT NULL AUTO_INCREMENT COMMENT '签到记录ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（sys_user.user_id）',
  `sign_date` date NOT NULL COMMENT '签到日期（东八区自然日，一天一条）',
  `points` int NOT NULL COMMENT '本次获得的积分（按当时连续天数取档，历史不被改写）',
  `continuous_days` int NOT NULL COMMENT '本次签到后的连续签到天数（断签从 1 重新开始）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`checkin_id`) USING BTREE,
  UNIQUE INDEX `uk_checkin_user_date`(`user_id` ASC, `sign_date` ASC) USING BTREE,
  INDEX `idx_checkin_user_date`(`user_id` ASC, `sign_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '签到记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_checkin
-- ----------------------------
INSERT INTO `learning_checkin` VALUES (35, 111, '2026-11-05', 1, 1, '2026-11-05 10:00:00');
INSERT INTO `learning_checkin` VALUES (36, 111, '2026-11-06', 2, 2, '2026-11-06 10:00:00');
INSERT INTO `learning_checkin` VALUES (37, 111, '2026-11-07', 3, 3, '2026-11-07 10:00:00');
INSERT INTO `learning_checkin` VALUES (38, 111, '2026-11-08', 4, 4, '2026-11-08 10:00:00');
INSERT INTO `learning_checkin` VALUES (39, 111, '2026-11-09', 5, 5, '2026-11-09 10:00:00');
INSERT INTO `learning_checkin` VALUES (40, 111, '2026-11-10', 6, 6, '2026-11-10 10:00:00');
INSERT INTO `learning_checkin` VALUES (41, 112, '2026-11-08', 1, 1, '2026-11-08 09:10:00');
INSERT INTO `learning_checkin` VALUES (42, 112, '2026-11-09', 2, 2, '2026-11-09 09:10:00');
INSERT INTO `learning_checkin` VALUES (43, 112, '2026-11-10', 3, 3, '2026-11-10 09:10:00');
INSERT INTO `learning_checkin` VALUES (44, 115, '2026-11-07', 1, 1, '2026-11-07 21:05:00');
INSERT INTO `learning_checkin` VALUES (45, 115, '2026-11-08', 2, 2, '2026-11-08 21:05:00');
INSERT INTO `learning_checkin` VALUES (46, 118, '2026-11-07', 1, 1, '2026-11-07 20:00:00');
INSERT INTO `learning_checkin` VALUES (47, 118, '2026-11-08', 2, 2, '2026-11-08 20:00:00');
INSERT INTO `learning_checkin` VALUES (49, 111, '2026-11-11', 7, 7, '2026-11-11 11:07:29');
INSERT INTO `learning_checkin` VALUES (50, 115, '2026-11-11', 5, 1, '2026-11-11 14:22:46');
INSERT INTO `learning_checkin` VALUES (51, 112, '2026-11-11', 12, 4, '2026-11-11 14:35:35');
INSERT INTO `learning_checkin` VALUES (52, 112, '2026-11-12', 5, 5, '2026-11-12 10:26:07');
INSERT INTO `learning_checkin` VALUES (53, 121, '2026-11-12', 1, 1, '2026-11-12 14:43:50');
INSERT INTO `learning_checkin` VALUES (55, 112, '2026-11-13', 6, 6, '2026-11-13 09:03:21');
INSERT INTO `learning_checkin` VALUES (56, 112, '2026-11-17', 1, 1, '2026-11-17 15:41:42');
INSERT INTO `learning_checkin` VALUES (57, 126, '2026-11-17', 1, 1, '2026-11-17 15:52:40');
INSERT INTO `learning_checkin` VALUES (58, 111, '2026-11-17', 1, 1, '2026-11-17 16:18:18');
INSERT INTO `learning_checkin` VALUES (59, 112, '2026-11-18', 2, 2, '2026-11-18 11:36:52');
INSERT INTO `learning_checkin` VALUES (60, 115, '2026-11-18', 1, 1, '2026-11-18 13:59:38');
INSERT INTO `learning_checkin` VALUES (61, 111, '2026-11-18', 2, 2, '2026-11-18 14:35:13');
INSERT INTO `learning_checkin` VALUES (62, 128, '2026-11-18', 1, 1, '2026-11-18 16:11:23');

-- ----------------------------
-- Table structure for learning_comment
-- ----------------------------
DROP TABLE IF EXISTS `learning_comment`;
CREATE TABLE `learning_comment`  (
  `comment_id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `user_id` bigint NOT NULL COMMENT '评论人用户ID（逻辑关联 sys_user.user_id）',
  `target_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目标类型（1帖子 2课程 3短视频）',
  `target_id` bigint NOT NULL COMMENT '目标ID',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父评论ID（一级评论为NULL；二级评论存所属一级评论的comment_id，不是直接父级）',
  `reply_user_id` bigint NULL DEFAULT NULL COMMENT '被回复人用户ID（仅二级评论有值；服务端从被回复评论的作者推导，不接受前端传入）',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论内容（纯文本，最长500字）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '评论时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间（逻辑删除时写入）',
  PRIMARY KEY (`comment_id`) USING BTREE,
  INDEX `idx_target`(`target_type` ASC, `target_id` ASC, `del_flag` ASC, `comment_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC, `del_flag` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC, `del_flag` ASC, `comment_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 180 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_comment
-- ----------------------------
INSERT INTO `learning_comment` VALUES (100, 106, '1', 101, NULL, NULL, '评论测试一级', '2', '2026-10-15 17:37:25', '2026-10-15 17:39:02');
INSERT INTO `learning_comment` VALUES (101, 106, '1', 101, 100, 106, '评论测试二级回复', '2', '2026-10-15 17:37:50', '2026-10-15 17:39:02');
INSERT INTO `learning_comment` VALUES (102, 112, '3', 100, NULL, NULL, 'hhh', '2', '2026-10-16 17:27:43', '2026-10-27 11:06:58');
INSERT INTO `learning_comment` VALUES (103, 111, '3', 201, NULL, NULL, '66666', '0', '2026-10-27 09:43:30', NULL);
INSERT INTO `learning_comment` VALUES (104, 111, '2', 203, NULL, NULL, 'Keyi', '0', '2026-10-27 09:45:56', NULL);
INSERT INTO `learning_comment` VALUES (105, 111, '3', 201, NULL, NULL, '1111111', '0', '2026-10-27 10:04:54', NULL);
INSERT INTO `learning_comment` VALUES (106, 112, '2', 203, NULL, NULL, 'HelloFromDSH', '0', '2026-10-27 10:05:04', NULL);
INSERT INTO `learning_comment` VALUES (107, 111, '2', 203, NULL, NULL, 'Yibanban', '0', '2026-10-27 10:55:16', NULL);
INSERT INTO `learning_comment` VALUES (108, 111, '3', 202, NULL, NULL, 'Ha ok Anna?', '0', '2026-10-27 11:03:28', NULL);
INSERT INTO `learning_comment` VALUES (109, 112, '1', 205, NULL, NULL, 'nice', '0', '2026-10-27 11:05:20', NULL);
INSERT INTO `learning_comment` VALUES (110, 112, '2', 203, NULL, NULL, '回复 @13900000001: zdjd', '0', '2026-10-27 11:06:05', NULL);
INSERT INTO `learning_comment` VALUES (111, 112, '2', 203, 106, 112, '回复测试', '0', '2026-10-27 14:15:22', NULL);
INSERT INTO `learning_comment` VALUES (112, 112, '2', 203, 106, 112, 'ReplyFromApp', '0', '2026-10-27 14:33:13', NULL);
INSERT INTO `learning_comment` VALUES (113, 112, '1', 203, NULL, NULL, 'ArticleRootComment', '0', '2026-10-27 14:33:31', NULL);
INSERT INTO `learning_comment` VALUES (114, 112, '1', 203, 113, 112, 'ArticleNestedReply', '0', '2026-10-27 14:33:31', NULL);
INSERT INTO `learning_comment` VALUES (115, 112, '2', 203, 107, 111, 'test', '0', '2026-10-27 14:44:14', NULL);
INSERT INTO `learning_comment` VALUES (116, 111, '1', 201, NULL, NULL, '6', '0', '2026-10-27 17:45:27', NULL);
INSERT INTO `learning_comment` VALUES (117, 118, '3', 201, NULL, NULL, '你好吗？', '0', '2026-10-27 18:46:04', NULL);
INSERT INTO `learning_comment` VALUES (118, 111, '3', 201, 117, 118, '你在干嘛啊兄弟?', '0', '2026-10-27 18:58:59', NULL);
INSERT INTO `learning_comment` VALUES (119, 118, '3', 201, 117, 118, 'Hhhh', '0', '2026-10-27 19:00:44', NULL);
INSERT INTO `learning_comment` VALUES (120, 118, '3', 201, 105, 111, '6', '0', '2026-10-27 19:21:43', NULL);
INSERT INTO `learning_comment` VALUES (121, 118, '3', 201, 117, 118, '你猜猜', '0', '2026-10-27 19:32:43', NULL);
INSERT INTO `learning_comment` VALUES (122, 118, '3', 201, 117, 118, '2222', '0', '2026-10-27 19:32:50', NULL);
INSERT INTO `learning_comment` VALUES (123, 118, '1', 205, NULL, NULL, '666', '0', '2026-10-27 20:17:09', NULL);
INSERT INTO `learning_comment` VALUES (124, 118, '1', 205, 123, 118, '666', '2', '2026-10-27 20:18:45', '2026-11-10 14:47:30');
INSERT INTO `learning_comment` VALUES (125, 118, '1', 205, 109, 112, '你也是人才', '0', '2026-10-27 20:35:13', NULL);
INSERT INTO `learning_comment` VALUES (126, 118, '1', 205, NULL, NULL, '哈哈哈', '0', '2026-10-27 20:35:24', NULL);
INSERT INTO `learning_comment` VALUES (127, 118, '1', 211, NULL, NULL, '讲的太好了，我要哭了', '2', '2026-10-28 10:56:39', '2026-11-10 14:34:35');
INSERT INTO `learning_comment` VALUES (128, 118, '2', 202, NULL, NULL, '实践出真知，不错', '0', '2026-10-28 10:58:46', NULL);
INSERT INTO `learning_comment` VALUES (129, 118, '2', 201, NULL, NULL, '听不懂啊', '0', '2026-10-28 10:59:37', NULL);
INSERT INTO `learning_comment` VALUES (130, 115, '1', 211, NULL, NULL, 'integration test comment A', '2', '2026-10-29 00:03:55', '2026-10-29 00:14:04');
INSERT INTO `learning_comment` VALUES (131, 119, '1', 211, 130, 115, 'integration test reply B', '2', '2026-10-29 00:03:56', '2026-10-29 00:14:04');
INSERT INTO `learning_comment` VALUES (132, 115, '2', 205, NULL, NULL, 'course comment for reply test', '2', '2026-10-29 00:35:48', '2026-10-29 00:43:01');
INSERT INTO `learning_comment` VALUES (133, 115, '2', 205, 132, 115, 'Reply ok', '2', '2026-10-29 00:39:30', '2026-10-29 00:43:01');
INSERT INTO `learning_comment` VALUES (134, 106, '1', 203, NULL, NULL, '这是一条测试评论', '0', '2026-10-29 14:14:20', NULL);
INSERT INTO `learning_comment` VALUES (135, 112, '1', 211, NULL, NULL, 'test-cmt', '2', '2026-10-29 14:30:03', '2026-10-29 14:30:43');
INSERT INTO `learning_comment` VALUES (136, 115, '2', 202, NULL, NULL, '666', '0', '2026-10-29 20:43:16', NULL);
INSERT INTO `learning_comment` VALUES (137, 111, '1', 216, NULL, NULL, 'Nice', '2', '2026-10-30 14:56:43', '2026-10-30 15:38:07');
INSERT INTO `learning_comment` VALUES (138, 112, '3', 203, NULL, NULL, '1¹1', '2', '2026-11-02 09:23:20', '2026-11-18 14:01:10');
INSERT INTO `learning_comment` VALUES (139, 115, '2', 201, NULL, NULL, '000000', '0', '2026-11-02 09:30:47', NULL);
INSERT INTO `learning_comment` VALUES (140, 115, '2', 201, 129, 118, '11111111', '0', '2026-11-02 09:31:26', NULL);
INSERT INTO `learning_comment` VALUES (141, 115, '1', 218, NULL, NULL, '111', '2', '2026-11-02 09:37:16', '2026-11-02 13:51:41');
INSERT INTO `learning_comment` VALUES (142, 112, '3', 201, NULL, NULL, '8888', '0', '2026-11-02 09:45:55', NULL);
INSERT INTO `learning_comment` VALUES (143, 112, '3', 201, 142, 112, '666', '2', '2026-11-02 09:46:07', '2026-11-18 12:19:11');
INSERT INTO `learning_comment` VALUES (144, 112, '1', 219, NULL, NULL, '9999', '2', '2026-11-02 09:49:24', '2026-11-02 10:02:19');
INSERT INTO `learning_comment` VALUES (145, 112, '1', 219, 144, 112, '88', '2', '2026-11-02 09:49:33', '2026-11-02 10:02:19');
INSERT INTO `learning_comment` VALUES (146, 115, '1', 214, NULL, NULL, '00000', '2', '2026-11-02 14:05:03', '2026-11-02 14:05:26');
INSERT INTO `learning_comment` VALUES (147, 115, '1', 214, 146, 115, '11111', '2', '2026-11-02 14:05:15', '2026-11-02 14:05:22');
INSERT INTO `learning_comment` VALUES (148, 111, '3', 201, NULL, NULL, '管理员删除测试评论', '2', '2026-11-02 16:19:00', '2026-11-02 16:19:02');
INSERT INTO `learning_comment` VALUES (149, 111, '2', 202, NULL, NULL, '222', '0', '2026-11-04 14:13:39', NULL);
INSERT INTO `learning_comment` VALUES (150, 111, '2', 202, 136, 115, '555', '0', '2026-11-04 14:13:53', NULL);
INSERT INTO `learning_comment` VALUES (151, 112, '1', 214, NULL, NULL, 'shazidx', '2', '2026-11-06 14:34:12', '2026-11-18 14:02:04');
INSERT INTO `learning_comment` VALUES (152, 112, '1', 211, NULL, NULL, 'zdjd', '0', '2026-11-06 14:34:35', NULL);
INSERT INTO `learning_comment` VALUES (153, 112, '1', 101, NULL, NULL, '1111', '0', '2026-11-06 14:56:34', NULL);
INSERT INTO `learning_comment` VALUES (154, 112, '1', 201, NULL, NULL, '666', '0', '2026-11-06 15:19:44', NULL);
INSERT INTO `learning_comment` VALUES (155, 112, '3', 203, NULL, NULL, '666', '2', '2026-11-06 15:20:50', '2026-11-06 15:39:48');
INSERT INTO `learning_comment` VALUES (156, 112, '1', 223, NULL, NULL, '1', '2', '2026-11-06 15:41:08', '2026-11-18 12:08:12');
INSERT INTO `learning_comment` VALUES (157, 112, '2', 202, NULL, NULL, '111', '0', '2026-11-06 15:42:17', NULL);
INSERT INTO `learning_comment` VALUES (158, 112, '3', 203, NULL, NULL, 'haoma', '2', '2026-11-06 16:08:38', '2026-11-06 16:09:15');
INSERT INTO `learning_comment` VALUES (159, 112, '3', 203, 138, 112, 'hiazai', '2', '2026-11-06 16:08:49', '2026-11-18 14:00:27');
INSERT INTO `learning_comment` VALUES (160, 112, '3', 201, 117, 118, '1111111111 1111111111111111111111', '0', '2026-11-06 16:21:40', NULL);
INSERT INTO `learning_comment` VALUES (161, 112, '1', 205, 109, 112, '111111111111111111111111', '2', '2026-11-06 16:23:00', '2026-11-06 16:30:11');
INSERT INTO `learning_comment` VALUES (162, 112, '3', 201, NULL, NULL, '12345', '2', '2026-11-09 10:49:39', '2026-11-18 12:18:38');
INSERT INTO `learning_comment` VALUES (163, 111, '3', 201, NULL, NULL, '管理员删除测试-评论', '2', '2026-11-10 09:39:43', '2026-11-10 09:39:44');
INSERT INTO `learning_comment` VALUES (164, 111, '3', 202, NULL, NULL, '级联测试-根评论', '2', '2026-11-10 09:40:07', '2026-11-10 09:40:10');
INSERT INTO `learning_comment` VALUES (165, 111, '3', 202, 164, 111, '级联测试-回复', '2', '2026-11-10 09:40:09', '2026-11-10 09:40:11');
INSERT INTO `learning_comment` VALUES (166, 121, '1', 101, NULL, NULL, '线上测试评论', '2', '2026-11-12 14:43:50', '2026-11-12 14:44:05');
INSERT INTO `learning_comment` VALUES (167, 121, '1', 101, 166, 121, '线上测试回复', '2', '2026-11-12 14:44:05', '2026-11-12 14:44:05');
INSERT INTO `learning_comment` VALUES (168, 112, '1', 223, 156, 112, '棒棒棒棒', '2', '2026-11-17 15:43:08', '2026-11-18 12:07:31');
INSERT INTO `learning_comment` VALUES (172, 112, '1', 223, 156, 112, 'multi——reply——test', '2', '2026-11-18 11:50:57', '2026-11-18 11:57:50');
INSERT INTO `learning_comment` VALUES (173, 112, '3', 201, 117, 112, 'video——reply——test', '2', '2026-11-18 11:54:58', '2026-11-18 11:55:51');
INSERT INTO `learning_comment` VALUES (174, 112, '1', 223, 156, 112, '111111', '2', '2026-11-18 11:58:24', '2026-11-18 11:58:30');
INSERT INTO `learning_comment` VALUES (175, 112, '3', 201, 105, 118, '111111', '0', '2026-11-18 13:48:46', NULL);
INSERT INTO `learning_comment` VALUES (176, 112, '3', 201, 117, 112, '1111', '2', '2026-11-18 13:48:55', '2026-11-18 13:48:58');
INSERT INTO `learning_comment` VALUES (177, 112, '1', 223, NULL, NULL, '11111', '2', '2026-11-18 13:49:27', '2026-11-18 13:53:14');
INSERT INTO `learning_comment` VALUES (178, 112, '1', 205, 109, 112, '我是大帅比', '0', '2026-11-18 16:04:40', NULL);
INSERT INTO `learning_comment` VALUES (179, 112, '1', 205, 123, 118, '你是不是ly', '0', '2026-11-18 16:04:53', NULL);

-- ----------------------------
-- Table structure for learning_course
-- ----------------------------
DROP TABLE IF EXISTS `learning_course`;
CREATE TABLE `learning_course`  (
  `course_id` bigint NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `course_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '课程名称',
  `category_id` bigint NULL DEFAULT NULL COMMENT '所属类别ID（逻辑关联 learning_category.category_id）',
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '封面图片地址（上传返回的相对路径 /profile/...）',
  `intro` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '课程简介',
  `like_count` int NOT NULL DEFAULT 0,
  `favorite_count` int NOT NULL DEFAULT 0,
  `comment_count` int NULL DEFAULT 0 COMMENT '评论数',
  `rating_count` int NULL DEFAULT 0 COMMENT '评分人数',
  `rating_score` int NULL DEFAULT 0 COMMENT '评分总分（各用户评分之和，平均分=本列/rating_count）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '阅读数（首次观看时 +1，由观看历史维护）',
  PRIMARY KEY (`course_id`) USING BTREE,
  INDEX `idx_course_category`(`category_id` ASC, `del_flag` ASC) USING BTREE,
  CONSTRAINT `chk_course_favorite_count` CHECK (`favorite_count` >= 0),
  CONSTRAINT `chk_course_like_count` CHECK (`like_count` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 206 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_course
-- ----------------------------
INSERT INTO `learning_course` VALUES (100, '大数据', 101, '/profile/upload/2026/10/13/曾俊杰-贵州大学_20261013154048A001.png', '把啊', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-13 15:41:00', '', '2026-10-13 15:41:29', '无', 0);
INSERT INTO `learning_course` VALUES (101, '测试课程A改', 101, '', '自动化测试', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-14 09:50:50', 'admin', '2026-10-14 11:39:19', NULL, 0);
INSERT INTO `learning_course` VALUES (102, '搜索测试课程', 101, '', '搜索测试', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 16:09:30', '', '2026-10-15 16:12:39', NULL, 0);
INSERT INTO `learning_course` VALUES (103, '分类测试课程A', 101, '', '测试', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 17:29:16', '', '2026-10-15 17:56:11', NULL, 0);
INSERT INTO `learning_course` VALUES (104, '分类测试课程B', 101, '', '测试', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 17:29:21', '', '2026-10-15 17:56:11', NULL, 0);
INSERT INTO `learning_course` VALUES (105, '分类测试课程C', 101, '', '测试', 0, 0, 0, 0, 0, '1', '2', 'admin', '2026-10-15 17:29:40', 'admin', '2026-10-15 17:56:11', NULL, 0);
INSERT INTO `learning_course` VALUES (107, '评分回归课程', 101, '', '回归', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-16 14:49:25', '', '2026-10-16 14:50:14', NULL, 0);
INSERT INTO `learning_course` VALUES (112, '笔记测试课程(可删)', NULL, '', '', 0, 0, 0, 0, 0, '0', '2', '', '2026-10-19 10:50:39', '', '2026-10-28 11:27:37', NULL, 0);
INSERT INTO `learning_course` VALUES (201, 'Java 从入门到实战', 101, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/3_20261027203937A003.jpg', '面向初学者的 Java 系统课程：环境搭建、语法基础、面向对象与集合框架', 2, 3, 3, 5, 21, '0', '0', 'admin', '2026-10-20 14:20:43', 'admin', '2026-11-10 09:11:28', '测试数据-前端调试', 5);
INSERT INTO `learning_course` VALUES (202, 'MySQL 性能优化实战', 103, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/2_20261027203926A002.jpg', '从索引原理到执行计划，实战排查慢查询与 SQL 优化', 2, 3, 5, 4, 18, '0', '0', 'admin', '2026-10-20 14:20:43', 'admin', '2026-10-28 09:39:13', '测试数据-前端调试', 5);
INSERT INTO `learning_course` VALUES (203, 'Redis 缓存原理与实战', 105, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/1_20261027203507A001.jpg', 'Redis 数据类型、持久化与缓存穿透/击穿/雪崩解决方案', 1, 1, 7, 2, 6, '0', '0', 'admin', '2026-10-20 14:20:43', 'admin', '2026-10-28 09:36:46', '测试数据-前端调试', 6);
INSERT INTO `learning_course` VALUES (204, 'Kafka入门与实践', 107, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/5_20261027222945A003.jpg', 'kafka新手小白入门', 1, 1, 0, 1, 4, '0', '0', 'admin', '2026-10-28 11:29:49', '', NULL, NULL, 5);
INSERT INTO `learning_course` VALUES (205, '计算机网络', 109, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/4_20261027223033A004.jpg', '计算机网络教程攻破', 0, 0, 0, 3, 11, '0', '0', 'admin', '2026-10-28 11:30:21', '', NULL, NULL, 7);

-- ----------------------------
-- Table structure for learning_course_chapter
-- ----------------------------
DROP TABLE IF EXISTS `learning_course_chapter`;
CREATE TABLE `learning_course_chapter`  (
  `chapter_id` bigint NOT NULL AUTO_INCREMENT COMMENT '章节ID',
  `course_id` bigint NOT NULL COMMENT '所属课程ID（逻辑关联 learning_course.course_id）',
  `chapter_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '章节标题',
  `chapter_content` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '章节内容（一段文字）',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`chapter_id`) USING BTREE,
  INDEX `idx_chapter_course`(`course_id` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 207 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台课程章节表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_course_chapter
-- ----------------------------
INSERT INTO `learning_course_chapter` VALUES (100, 101, '第一章改', '改后内容', 1, '2', 'admin', '2026-10-14 11:34:17', 'admin', '2026-10-14 11:39:11');
INSERT INTO `learning_course_chapter` VALUES (201, 201, '第一章 环境搭建与语法基础', 'JDK 安装、IDE 配置、Hello World 与基础语法讲解', 1, '0', 'admin', '2026-10-20 14:20:55', '', NULL);
INSERT INTO `learning_course_chapter` VALUES (202, 201, '第二章 面向对象与集合', '类与对象、继承多态、List/Map 集合的使用', 2, '0', 'admin', '2026-10-20 14:20:55', '', NULL);
INSERT INTO `learning_course_chapter` VALUES (203, 202, '第一章 索引与执行计划', 'B+ 树索引原理、EXPLAIN 执行计划解读', 1, '0', 'admin', '2026-10-20 14:20:55', '', NULL);
INSERT INTO `learning_course_chapter` VALUES (204, 202, '第二章 SQL 优化实战', '慢查询定位、索引优化与分页优化', 2, '0', 'admin', '2026-10-20 14:20:55', '', NULL);
INSERT INTO `learning_course_chapter` VALUES (205, 203, '第一章 数据类型与持久化', 'String/Hash/List 类型、RDB 与 AOF 持久化', 1, '0', 'admin', '2026-10-20 14:20:55', '', NULL);
INSERT INTO `learning_course_chapter` VALUES (206, 203, '第二章 缓存策略与实战', '缓存穿透、击穿、雪崩及分布式锁实践', 2, '0', 'admin', '2026-10-20 14:20:55', '', NULL);

-- ----------------------------
-- Table structure for learning_course_progress
-- ----------------------------
DROP TABLE IF EXISTS `learning_course_progress`;
CREATE TABLE `learning_course_progress`  (
  `progress_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID（逻辑关联 sys_user.user_id）',
  `course_id` bigint NOT NULL COMMENT '课程ID（逻辑关联 learning_course.course_id）',
  `video_id` bigint NOT NULL COMMENT '课程小节ID（逻辑关联 learning_course_video.video_id）',
  `finished` tinyint NOT NULL DEFAULT 0 COMMENT '是否学完（0否 1是，置 1 后不会回退）',
  `watched_seconds` int NOT NULL DEFAULT 0 COMMENT '该小节累计学习秒数',
  `create_time` datetime NULL DEFAULT NULL COMMENT '首次学习时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最近更新时间',
  PRIMARY KEY (`progress_id`) USING BTREE,
  UNIQUE INDEX `uk_progress_user_video`(`user_id` ASC, `video_id` ASC) USING BTREE,
  INDEX `idx_progress_user_course`(`user_id` ASC, `course_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 98 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '课程小节学习进度' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_course_progress
-- ----------------------------
INSERT INTO `learning_course_progress` VALUES (1, 111, 201, 201, 1, 1000, '2026-11-02 09:37:56', '2026-11-02 10:38:07');
INSERT INTO `learning_course_progress` VALUES (3, 111, 201, 202, 1, 190, '2026-11-02 09:37:58', '2026-11-02 10:53:20');
INSERT INTO `learning_course_progress` VALUES (5, 111, 202, 203, 0, 141, '2026-11-02 09:38:19', '2026-11-17 10:56:01');
INSERT INTO `learning_course_progress` VALUES (9, 111, 203, 205, 0, 60, '2026-11-02 10:38:07', '2026-11-02 10:38:07');
INSERT INTO `learning_course_progress` VALUES (17, 115, 201, 201, 1, 50, '2026-11-05 16:16:01', '2026-11-11 17:28:40');
INSERT INTO `learning_course_progress` VALUES (18, 115, 202, 203, 0, 230, '2026-11-06 21:19:58', '2026-11-11 17:35:45');
INSERT INTO `learning_course_progress` VALUES (21, 118, 201, 201, 0, 45, '2026-11-11 10:31:07', '2026-11-11 10:31:09');
INSERT INTO `learning_course_progress` VALUES (24, 118, 201, 202, 0, 30, '2026-11-11 10:32:42', '2026-11-11 10:32:42');
INSERT INTO `learning_course_progress` VALUES (46, 112, 201, 201, 1, 133, '2026-11-13 11:10:18', '2026-11-17 17:26:38');
INSERT INTO `learning_course_progress` VALUES (58, 112, 202, 203, 1, 244, '2026-11-17 15:50:25', '2026-11-17 16:13:13');
INSERT INTO `learning_course_progress` VALUES (59, 112, 201, 202, 1, 15, '2026-11-17 15:52:10', '2026-11-17 15:56:10');
INSERT INTO `learning_course_progress` VALUES (65, 112, 202, 204, 1, 55, '2026-11-17 15:59:28', '2026-11-17 16:03:03');

-- ----------------------------
-- Table structure for learning_course_rating
-- ----------------------------
DROP TABLE IF EXISTS `learning_course_rating`;
CREATE TABLE `learning_course_rating`  (
  `rating_id` bigint NOT NULL AUTO_INCREMENT COMMENT '评分ID',
  `course_id` bigint NOT NULL COMMENT '课程ID（逻辑关联 learning_course.course_id）',
  `user_id` bigint NOT NULL COMMENT '评分人用户ID（逻辑关联 sys_user.user_id）',
  `score` tinyint NOT NULL COMMENT '评分（1-5的整数）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '首次评分时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最近一次修改时间（没改过为 null）',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文字评价（可空）',
  PRIMARY KEY (`rating_id`) USING BTREE,
  UNIQUE INDEX `uk_course_user`(`course_id` ASC, `user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 129 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台课程评分表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_course_rating
-- ----------------------------
INSERT INTO `learning_course_rating` VALUES (107, 203, 111, 4, '2026-10-27 09:45:43', '2026-10-27 10:55:07', NULL);
INSERT INTO `learning_course_rating` VALUES (108, 202, 118, 5, '2026-10-28 10:58:28', NULL, NULL);
INSERT INTO `learning_course_rating` VALUES (109, 201, 118, 3, '2026-10-28 10:59:20', '2026-10-28 10:59:24', NULL);
INSERT INTO `learning_course_rating` VALUES (110, 205, 118, 5, '2026-10-28 13:58:23', NULL, NULL);
INSERT INTO `learning_course_rating` VALUES (111, 202, 115, 5, '2026-10-29 20:43:09', NULL, NULL);
INSERT INTO `learning_course_rating` VALUES (112, 201, 115, 5, '2026-11-02 09:30:29', '2026-11-02 09:30:31', NULL);
INSERT INTO `learning_course_rating` VALUES (116, 201, 106, 5, '2026-11-02 09:45:50', '2026-11-02 09:47:30', '讲得很清楚，示例能直接跑通，第二章作业设计尤其好');
INSERT INTO `learning_course_rating` VALUES (117, 201, 111, 4, '2026-11-02 09:45:51', '2026-11-02 10:56:26', NULL);
INSERT INTO `learning_course_rating` VALUES (121, 202, 111, 5, '2026-11-04 14:13:21', '2026-11-04 14:13:32', '666');
INSERT INTO `learning_course_rating` VALUES (122, 205, 112, 3, '2026-11-06 14:02:47', '2026-11-06 14:27:14', NULL);
INSERT INTO `learning_course_rating` VALUES (123, 202, 112, 3, '2026-11-06 14:03:06', '2026-11-09 09:08:11', '1111');
INSERT INTO `learning_course_rating` VALUES (124, 204, 112, 4, '2026-11-06 14:27:58', '2026-11-06 14:27:59', NULL);
INSERT INTO `learning_course_rating` VALUES (125, 203, 112, 2, '2026-11-06 14:43:26', NULL, NULL);
INSERT INTO `learning_course_rating` VALUES (126, 201, 112, 3, '2026-11-09 09:10:23', '2026-11-09 10:47:13', 'S');
INSERT INTO `learning_course_rating` VALUES (128, 205, 121, 3, '2026-11-12 14:43:50', '2026-11-12 14:44:05', '线上测试评价-改三星');

-- ----------------------------
-- Table structure for learning_course_video
-- ----------------------------
DROP TABLE IF EXISTS `learning_course_video`;
CREATE TABLE `learning_course_video`  (
  `video_id` bigint NOT NULL AUTO_INCREMENT COMMENT '视频ID',
  `course_id` bigint NOT NULL COMMENT '所属课程ID（逻辑关联 learning_course.course_id）',
  `chapter_id` bigint NULL DEFAULT NULL COMMENT '所属章节ID（逻辑关联 learning_course_chapter.chapter_id，为空表示无章节）',
  `video_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频标题',
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '视频地址（上传返回的相对路径 /profile/...）',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `duration` int NULL DEFAULT NULL COMMENT '时长（秒，可空）',
  PRIMARY KEY (`video_id`) USING BTREE,
  INDEX `idx_video_course`(`course_id` ASC, `del_flag` ASC) USING BTREE,
  INDEX `idx_video_chapter`(`chapter_id` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 207 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台课程视频表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_course_video
-- ----------------------------
INSERT INTO `learning_course_video` VALUES (100, 101, NULL, '第一课视频改', 'http://example.com/v2.mp4', 1, '2', 'admin', '2026-10-14 11:36:47', 'admin', '2026-10-14 11:39:19', NULL);
INSERT INTO `learning_course_video` VALUES (105, 112, NULL, '笔记测试小节(可删)', '/profile/upload/test.mp4', 1, '2', '', '2026-10-19 10:50:39', '', '2026-10-28 11:27:38', NULL);
INSERT INTO `learning_course_video` VALUES (201, 201, 201, '01-环境搭建与第一个程序', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/java-intro.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL, 615);
INSERT INTO `learning_course_video` VALUES (202, 201, 202, '02-面向对象核心概念', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/java-intro.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL, NULL);
INSERT INTO `learning_course_video` VALUES (203, 202, 203, '01-索引原理与 EXPLAIN', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/mysql-optimize.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL, 52);
INSERT INTO `learning_course_video` VALUES (204, 202, 204, '02-慢 SQL 实战调优', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/mysql-optimize.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL, NULL);
INSERT INTO `learning_course_video` VALUES (205, 203, 205, '01-Redis 数据类型精讲', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/redis-cache.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL, NULL);
INSERT INTO `learning_course_video` VALUES (206, 203, 206, '02-缓存三兄弟解决方案', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/redis-cache.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL, NULL);

-- ----------------------------
-- Table structure for learning_follow
-- ----------------------------
DROP TABLE IF EXISTS `learning_follow`;
CREATE TABLE `learning_follow`  (
  `follow_id` bigint NOT NULL AUTO_INCREMENT COMMENT '关注ID',
  `user_id` bigint NOT NULL COMMENT '关注者用户ID（逻辑关联 sys_user.user_id）',
  `follow_user_id` bigint NOT NULL COMMENT '被关注用户ID（逻辑关联 sys_user.user_id）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '关注时间',
  PRIMARY KEY (`follow_id`) USING BTREE,
  UNIQUE INDEX `uk_user_follow`(`user_id` ASC, `follow_user_id` ASC) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_follow_user_time`(`follow_user_id` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台用户关注表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_follow
-- ----------------------------
INSERT INTO `learning_follow` VALUES (106, 112, 111, '2026-10-27 11:38:45');
INSERT INTO `learning_follow` VALUES (107, 119, 115, '2026-10-28 23:52:02');
INSERT INTO `learning_follow` VALUES (109, 115, 119, '2026-10-29 00:18:55');
INSERT INTO `learning_follow` VALUES (115, 115, 118, '2026-10-29 11:02:29');
INSERT INTO `learning_follow` VALUES (116, 106, 111, '2026-10-29 14:14:21');
INSERT INTO `learning_follow` VALUES (117, 118, 111, '2026-10-30 09:51:30');
INSERT INTO `learning_follow` VALUES (118, 111, 118, '2026-10-30 15:24:24');
INSERT INTO `learning_follow` VALUES (119, 112, 115, '2026-11-02 09:49:56');
INSERT INTO `learning_follow` VALUES (120, 115, 112, '2026-11-02 14:04:36');
INSERT INTO `learning_follow` VALUES (121, 112, 106, '2026-11-18 10:46:31');

-- ----------------------------
-- Table structure for learning_interaction
-- ----------------------------
DROP TABLE IF EXISTS `learning_interaction`;
CREATE TABLE `learning_interaction`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID（逻辑关联 sys_user.user_id）',
  `target_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目标类型（1帖子 2课程 3短视频）',
  `target_id` bigint NOT NULL COMMENT '目标ID',
  `type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '行为类型（1点赞 2收藏）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '发生时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_target`(`user_id` ASC, `target_type` ASC, `target_id` ASC, `type` ASC) USING BTREE,
  INDEX `idx_target`(`target_type` ASC, `target_id` ASC, `type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 555 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台点赞收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_interaction
-- ----------------------------
INSERT INTO `learning_interaction` VALUES (185, 111, '3', 201, '2', '2026-10-27 10:04:46');
INSERT INTO `learning_interaction` VALUES (189, 111, '3', 202, '2', '2026-10-27 11:07:33');
INSERT INTO `learning_interaction` VALUES (193, 111, '3', 201, '1', '2026-10-27 17:54:22');
INSERT INTO `learning_interaction` VALUES (206, 118, '3', 201, '1', '2026-10-27 19:00:10');
INSERT INTO `learning_interaction` VALUES (207, 118, '3', 201, '2', '2026-10-27 19:00:11');
INSERT INTO `learning_interaction` VALUES (208, 118, '1', 205, '1', '2026-10-27 19:58:45');
INSERT INTO `learning_interaction` VALUES (209, 118, '1', 205, '2', '2026-10-27 19:59:12');
INSERT INTO `learning_interaction` VALUES (226, 118, '1', 204, '1', '2026-10-28 15:47:35');
INSERT INTO `learning_interaction` VALUES (227, 118, '1', 204, '2', '2026-10-28 15:47:36');
INSERT INTO `learning_interaction` VALUES (230, 112, '2', 202, '2', '2026-10-28 15:57:05');
INSERT INTO `learning_interaction` VALUES (233, 118, '2', 201, '1', '2026-10-28 16:08:13');
INSERT INTO `learning_interaction` VALUES (234, 118, '2', 201, '2', '2026-10-28 16:08:15');
INSERT INTO `learning_interaction` VALUES (235, 115, '3', 201, '1', '2026-10-28 16:27:03');
INSERT INTO `learning_interaction` VALUES (236, 115, '1', 211, '1', '2026-10-28 17:25:34');
INSERT INTO `learning_interaction` VALUES (245, 115, '2', 201, '1', '2026-10-28 19:56:21');
INSERT INTO `learning_interaction` VALUES (246, 115, '2', 201, '2', '2026-10-28 19:56:23');
INSERT INTO `learning_interaction` VALUES (249, 106, '1', 201, '1', '2026-10-29 14:14:19');
INSERT INTO `learning_interaction` VALUES (250, 106, '1', 202, '2', '2026-10-29 14:14:19');
INSERT INTO `learning_interaction` VALUES (260, 112, '2', 201, '2', '2026-10-29 15:44:25');
INSERT INTO `learning_interaction` VALUES (438, 115, '2', 202, '1', '2026-10-29 20:43:02');
INSERT INTO `learning_interaction` VALUES (439, 115, '2', 202, '2', '2026-10-29 20:43:04');
INSERT INTO `learning_interaction` VALUES (454, 111, '3', 203, '1', '2026-10-30 14:03:46');
INSERT INTO `learning_interaction` VALUES (455, 111, '3', 203, '2', '2026-10-30 14:03:48');
INSERT INTO `learning_interaction` VALUES (458, 112, '3', 203, '1', '2026-11-02 09:23:10');
INSERT INTO `learning_interaction` VALUES (476, 115, '1', 214, '1', '2026-11-02 14:04:52');
INSERT INTO `learning_interaction` VALUES (477, 115, '1', 214, '2', '2026-11-02 14:04:54');
INSERT INTO `learning_interaction` VALUES (480, 111, '2', 202, '2', '2026-11-04 14:26:56');
INSERT INTO `learning_interaction` VALUES (481, 111, '1', 223, '1', '2026-11-04 14:55:00');
INSERT INTO `learning_interaction` VALUES (487, 112, '1', 223, '2', '2026-11-06 09:40:02');
INSERT INTO `learning_interaction` VALUES (492, 112, '3', 203, '2', '2026-11-06 09:51:38');
INSERT INTO `learning_interaction` VALUES (499, 115, '3', 202, '1', '2026-11-06 10:49:29');
INSERT INTO `learning_interaction` VALUES (501, 112, '1', 214, '2', '2026-11-06 11:13:51');
INSERT INTO `learning_interaction` VALUES (506, 112, '2', 204, '2', '2026-11-06 14:28:19');
INSERT INTO `learning_interaction` VALUES (507, 112, '2', 204, '1', '2026-11-06 14:28:22');
INSERT INTO `learning_interaction` VALUES (508, 112, '1', 211, '2', '2026-11-06 14:29:08');
INSERT INTO `learning_interaction` VALUES (509, 112, '1', 211, '1', '2026-11-06 14:29:09');
INSERT INTO `learning_interaction` VALUES (510, 112, '1', 223, '1', '2026-11-06 14:29:35');
INSERT INTO `learning_interaction` VALUES (512, 112, '2', 203, '1', '2026-11-06 14:43:16');
INSERT INTO `learning_interaction` VALUES (514, 112, '2', 203, '2', '2026-11-06 14:43:20');
INSERT INTO `learning_interaction` VALUES (525, 112, '3', 202, '1', '2026-11-06 15:16:14');
INSERT INTO `learning_interaction` VALUES (526, 112, '3', 202, '2', '2026-11-06 15:16:15');
INSERT INTO `learning_interaction` VALUES (541, 115, '3', 203, '1', '2026-11-11 17:29:17');
INSERT INTO `learning_interaction` VALUES (547, 112, '1', 214, '1', '2026-11-17 16:02:52');
INSERT INTO `learning_interaction` VALUES (548, 111, '1', 214, '1', '2026-11-17 16:12:59');
INSERT INTO `learning_interaction` VALUES (549, 111, '1', 214, '2', '2026-11-17 16:13:04');
INSERT INTO `learning_interaction` VALUES (552, 111, '2', 202, '1', '2026-11-18 14:49:37');
INSERT INTO `learning_interaction` VALUES (553, 112, '1', 205, '1', '2026-11-18 16:05:07');
INSERT INTO `learning_interaction` VALUES (554, 112, '1', 205, '2', '2026-11-18 16:05:10');

-- ----------------------------
-- Table structure for learning_note
-- ----------------------------
DROP TABLE IF EXISTS `learning_note`;
CREATE TABLE `learning_note`  (
  `note_id` bigint NOT NULL AUTO_INCREMENT COMMENT '笔记ID',
  `user_id` bigint NOT NULL COMMENT '作者用户ID（sys_user.user_id，一律取 API 上下文）',
  `target_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '挂载类型：post=帖子（文章笔记） video=课程小节（视频笔记，挂 learning_course_video.video_id）',
  `target_id` bigint NOT NULL COMMENT '挂载目标ID：post_id 或 课程小节的 video_id',
  `note_title` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题（纯文本，≤20字）',
  `note_content` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '正文（纯文本，≤800字）',
  `progress` int NULL DEFAULT NULL COMMENT '视频笔记：记笔记时的播放位置(秒)；文章笔记为 NULL。仅展示用，跳转时从头播放',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间（列表按它倒序 = 最近编辑在前）',
  PRIMARY KEY (`note_id`) USING BTREE,
  INDEX `idx_note_user`(`user_id` ASC, `del_flag` ASC, `update_time` ASC) USING BTREE,
  INDEX `idx_note_target`(`target_type` ASC, `target_id` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户笔记（课程小节 / 帖子）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_note
-- ----------------------------
INSERT INTO `learning_note` VALUES (6, 111, 'video', 105, '自检', 'ok', 88, '2', '2026-10-19 10:50:46', '2026-10-19 10:50:47');
INSERT INTO `learning_note` VALUES (7, 111, 'post', 101, '文章笔记测试', '这是一条文章笔记正文', NULL, '2', '2026-10-19 11:32:57', '2026-10-19 11:35:52');
INSERT INTO `learning_note` VALUES (8, 111, 'video', 105, '视频笔记改', '改后正文', 1250, '2', '2026-10-19 11:33:12', '2026-10-19 11:51:50');
INSERT INTO `learning_note` VALUES (9, 111, 'post', 101, '来源删除后仍可编辑', 'ok', NULL, '2', '2026-10-19 11:44:11', '2026-10-19 11:55:44');
INSERT INTO `learning_note` VALUES (10, 111, 'post', 101, 'JSON提交测试改', 'json edit', NULL, '2', '2026-10-19 11:50:34', '2026-10-19 11:51:20');
INSERT INTO `learning_note` VALUES (13, 118, 'post', 205, '从单体到微服务的架构演进', '66666', NULL, '0', '2026-10-27 20:55:39', '2026-10-27 20:55:39');
INSERT INTO `learning_note` VALUES (14, 115, 'video', 201, '01-环境搭建与第一个程序', 'Tst', 9, '0', '2026-10-28 19:57:15', '2026-10-28 19:57:15');
INSERT INTO `learning_note` VALUES (15, 115, 'video', 201, 'Sintel 开源短片 · 片段一', 'Note from short video', 0, '0', '2026-10-29 00:32:55', '2026-10-29 00:32:55');
INSERT INTO `learning_note` VALUES (16, 111, 'post', 211, '计算机网络3天速成', '6sd6a6dadacvav jvjbv', NULL, '2', '2026-10-30 16:29:49', '2026-10-30 16:30:48');
INSERT INTO `learning_note` VALUES (17, 111, 'video', 201, 'Sintel 开源短片 · 片段一', '5555555', 0, '2', '2026-10-30 16:30:18', '2026-10-30 16:30:41');
INSERT INTO `learning_note` VALUES (18, 112, 'post', 211, '112', '不相信', NULL, '0', '2026-11-02 14:34:58', '2026-11-02 14:34:58');
INSERT INTO `learning_note` VALUES (19, 112, 'video', 205, '112', '可以', NULL, '0', '2026-11-02 14:35:53', '2026-11-02 14:35:53');
INSERT INTO `learning_note` VALUES (20, 111, 'video', 203, '01-索引原理与 EXPLAIN', 'Fuck', 0, '0', '2026-11-04 14:16:17', '2026-11-04 14:16:17');
INSERT INTO `learning_note` VALUES (21, 111, 'video', 203, 'Sintel 开源短片 · 片段三', '22222', 0, '0', '2026-11-04 14:17:06', '2026-11-04 14:17:06');
INSERT INTO `learning_note` VALUES (22, 111, 'post', 214, 'test', '11111', NULL, '0', '2026-11-04 14:28:22', '2026-11-04 14:28:22');
INSERT INTO `learning_note` VALUES (23, 115, 'video', 203, '01-索引原理与 EXPLAIN', '1', 20, '0', '2026-11-06 21:20:18', '2026-11-06 21:20:18');
INSERT INTO `learning_note` VALUES (24, 112, 'video', 202, '21', 'hhhh', NULL, '0', '2026-11-09 09:11:24', '2026-11-09 09:11:24');

-- ----------------------------
-- Table structure for learning_notification
-- ----------------------------
DROP TABLE IF EXISTS `learning_notification`;
CREATE TABLE `learning_notification`  (
  `notification_id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` bigint NOT NULL COMMENT '接收者用户ID（被触发者，逻辑关联 sys_user.user_id）',
  `from_user_id` bigint NOT NULL COMMENT '触发者用户ID（点头像的那位，逻辑关联 sys_user.user_id）',
  `type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知类型（1点赞 2收藏 3评论 4关注 5回复评论）',
  `target_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标类型（1帖子 3短视频；关注类为NULL；课程永不产生通知）',
  `target_id` bigint NULL DEFAULT NULL COMMENT '目标ID（关注类为NULL）',
  `comment_id` bigint NULL DEFAULT NULL COMMENT '关联评论ID（评论/回复通知用；历史通知为空）',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '评论摘要（仅评论类有值，与 learning_comment.content 一致）',
  `is_read` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '读取状态（0未读 1已读）',
  `read_time` datetime NULL DEFAULT NULL COMMENT '读取时间（未读为NULL）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '产生时间',
  PRIMARY KEY (`notification_id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_user_read_time`(`user_id` ASC, `is_read` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_notification_comment`(`comment_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 343 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台用户通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_notification
-- ----------------------------
INSERT INTO `learning_notification` VALUES (100, 1, 106, '3', '1', 101, NULL, '评论测试一级', '0', NULL, '2026-10-15 17:37:25');
INSERT INTO `learning_notification` VALUES (101, 1, 106, '3', '1', 101, NULL, '评论测试二级回复', '0', NULL, '2026-10-15 17:37:50');
INSERT INTO `learning_notification` VALUES (102, 104, 106, '4', NULL, NULL, NULL, NULL, '0', NULL, '2026-10-15 17:53:56');
INSERT INTO `learning_notification` VALUES (103, 1, 106, '4', NULL, NULL, NULL, NULL, '0', NULL, '2026-10-15 17:54:13');
INSERT INTO `learning_notification` VALUES (104, 104, 106, '1', '3', 100, NULL, NULL, '0', NULL, '2026-10-15 17:55:55');
INSERT INTO `learning_notification` VALUES (105, 104, 111, '1', '3', 100, NULL, NULL, '0', NULL, '2026-10-16 14:15:56');
INSERT INTO `learning_notification` VALUES (106, 104, 112, '1', '3', 100, NULL, NULL, '0', NULL, '2026-10-16 16:58:18');
INSERT INTO `learning_notification` VALUES (107, 104, 112, '1', '3', 100, NULL, NULL, '0', NULL, '2026-10-16 16:58:19');
INSERT INTO `learning_notification` VALUES (108, 104, 112, '1', '3', 100, NULL, NULL, '0', NULL, '2026-10-16 16:58:20');
INSERT INTO `learning_notification` VALUES (109, 104, 112, '2', '3', 100, NULL, NULL, '0', NULL, '2026-10-16 16:58:27');
INSERT INTO `learning_notification` VALUES (110, 104, 112, '1', '3', 100, NULL, NULL, '0', NULL, '2026-10-16 16:58:47');
INSERT INTO `learning_notification` VALUES (111, 104, 112, '3', '3', 100, NULL, 'hhh', '0', NULL, '2026-10-16 17:27:43');
INSERT INTO `learning_notification` VALUES (116, 104, 111, '1', '3', 100, NULL, NULL, '0', NULL, '2026-10-22 14:15:42');
INSERT INTO `learning_notification` VALUES (117, 104, 111, '1', '3', 100, NULL, NULL, '0', NULL, '2026-10-22 14:47:29');
INSERT INTO `learning_notification` VALUES (119, 104, 111, '1', '3', 100, NULL, NULL, '0', NULL, '2026-10-27 09:42:56');
INSERT INTO `learning_notification` VALUES (132, 118, 111, '5', '3', 201, 118, '你在干嘛啊兄弟?', '1', '2026-10-28 11:02:25', '2026-10-27 18:58:59');
INSERT INTO `learning_notification` VALUES (143, 112, 118, '5', '1', 205, 125, '你也是人才', '1', '2026-10-28 11:28:03', '2026-10-27 20:35:13');
INSERT INTO `learning_notification` VALUES (153, 118, 115, '1', '1', 211, NULL, NULL, '1', '2026-10-30 09:51:15', '2026-10-28 17:25:34');
INSERT INTO `learning_notification` VALUES (154, 115, 119, '4', NULL, NULL, NULL, NULL, '1', '2026-10-29 00:02:24', '2026-10-28 23:52:02');
INSERT INTO `learning_notification` VALUES (155, 119, 115, '4', NULL, NULL, NULL, NULL, '0', NULL, '2026-10-28 23:52:10');
INSERT INTO `learning_notification` VALUES (156, 118, 115, '3', '1', 211, NULL, 'integration test comment A', '1', '2026-10-30 09:51:15', '2026-10-29 00:03:55');
INSERT INTO `learning_notification` VALUES (157, 115, 119, '5', '1', 211, NULL, 'integration test reply B', '1', '2026-10-29 00:04:26', '2026-10-29 00:03:56');
INSERT INTO `learning_notification` VALUES (158, 118, 119, '3', '1', 211, NULL, 'integration test reply B', '1', '2026-10-30 09:51:15', '2026-10-29 00:03:56');
INSERT INTO `learning_notification` VALUES (159, 118, 115, '2', '1', 211, NULL, NULL, '1', '2026-10-30 09:51:15', '2026-10-29 00:15:19');
INSERT INTO `learning_notification` VALUES (160, 119, 115, '4', NULL, NULL, NULL, NULL, '0', NULL, '2026-10-29 00:18:55');
INSERT INTO `learning_notification` VALUES (164, 118, 115, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:51:15', '2026-10-29 10:55:16');
INSERT INTO `learning_notification` VALUES (166, 118, 115, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:51:15', '2026-10-29 11:02:29');
INSERT INTO `learning_notification` VALUES (172, 111, 106, '1', '1', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 14:14:19');
INSERT INTO `learning_notification` VALUES (173, 111, 106, '2', '1', 202, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 14:14:20');
INSERT INTO `learning_notification` VALUES (174, 111, 106, '3', '1', 203, 134, '这是一条测试评论', '1', '2026-10-30 09:52:15', '2026-10-29 14:14:20');
INSERT INTO `learning_notification` VALUES (175, 111, 106, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 14:14:21');
INSERT INTO `learning_notification` VALUES (176, 111, 104, '1', '1', 202, NULL, NULL, '1', '2026-10-26 15:18:34', '2026-10-26 15:18:34');
INSERT INTO `learning_notification` VALUES (177, 111, 1, '1', '1', 203, NULL, NULL, '1', '2026-10-26 14:18:34', '2026-10-26 14:18:34');
INSERT INTO `learning_notification` VALUES (178, 111, 106, '1', '3', 201, NULL, NULL, '1', '2026-10-26 13:18:34', '2026-10-26 13:18:34');
INSERT INTO `learning_notification` VALUES (179, 111, 104, '1', '1', 205, NULL, NULL, '1', '2026-10-26 12:18:34', '2026-10-26 12:18:34');
INSERT INTO `learning_notification` VALUES (180, 111, 1, '1', '1', 201, NULL, NULL, '1', '2026-10-26 11:18:34', '2026-10-26 11:18:34');
INSERT INTO `learning_notification` VALUES (181, 111, 106, '1', '3', 201, NULL, NULL, '1', '2026-10-26 10:18:34', '2026-10-26 10:18:34');
INSERT INTO `learning_notification` VALUES (182, 111, 104, '1', '1', 203, NULL, NULL, '1', '2026-10-26 09:18:34', '2026-10-26 09:18:34');
INSERT INTO `learning_notification` VALUES (183, 111, 1, '1', '1', 204, NULL, NULL, '1', '2026-10-26 08:18:34', '2026-10-26 08:18:34');
INSERT INTO `learning_notification` VALUES (184, 111, 106, '1', '3', 201, NULL, NULL, '1', '2026-10-26 07:18:34', '2026-10-26 07:18:34');
INSERT INTO `learning_notification` VALUES (185, 111, 104, '1', '1', 201, NULL, NULL, '1', '2026-10-26 06:18:34', '2026-10-26 06:18:34');
INSERT INTO `learning_notification` VALUES (186, 111, 1, '2', '1', 202, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-26 05:18:34');
INSERT INTO `learning_notification` VALUES (187, 111, 106, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-26 04:18:34');
INSERT INTO `learning_notification` VALUES (188, 111, 104, '2', '1', 204, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-26 03:18:34');
INSERT INTO `learning_notification` VALUES (189, 111, 1, '2', '1', 205, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-26 02:18:34');
INSERT INTO `learning_notification` VALUES (190, 111, 106, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-26 01:18:34');
INSERT INTO `learning_notification` VALUES (191, 111, 104, '2', '1', 202, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-26 00:18:34');
INSERT INTO `learning_notification` VALUES (192, 111, 1, '2', '1', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 23:18:34');
INSERT INTO `learning_notification` VALUES (193, 111, 106, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 22:18:34');
INSERT INTO `learning_notification` VALUES (194, 111, 104, '2', '1', 205, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 21:18:34');
INSERT INTO `learning_notification` VALUES (195, 111, 1, '2', '1', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 20:18:34');
INSERT INTO `learning_notification` VALUES (196, 111, 106, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 19:18:34');
INSERT INTO `learning_notification` VALUES (197, 111, 104, '3', '1', 203, NULL, '正好在学这块，感谢分享', '1', '2026-10-30 09:52:15', '2026-10-25 18:18:34');
INSERT INTO `learning_notification` VALUES (198, 111, 1, '3', '1', 204, NULL, '有个小问题想请教：并发场景下怎么处理？', '1', '2026-10-30 09:52:15', '2026-10-25 17:18:34');
INSERT INTO `learning_notification` VALUES (199, 111, 106, '3', '1', 205, NULL, '总结得很到位', '1', '2026-10-30 09:52:15', '2026-10-25 16:18:34');
INSERT INTO `learning_notification` VALUES (200, 111, 104, '3', '1', 201, NULL, '讲得太细了，赞一个', '1', '2026-10-30 09:52:15', '2026-10-25 15:18:34');
INSERT INTO `learning_notification` VALUES (201, 111, 1, '3', '1', 202, NULL, '这个坑我也踩过', '1', '2026-10-30 09:52:15', '2026-10-25 14:18:34');
INSERT INTO `learning_notification` VALUES (202, 111, 106, '3', '1', 203, NULL, '看完受益匪浅', '1', '2026-10-30 09:52:15', '2026-10-25 13:18:34');
INSERT INTO `learning_notification` VALUES (203, 111, 104, '3', '1', 204, NULL, '例子能再详细点就更好了', '1', '2026-10-30 09:52:15', '2026-10-25 12:18:34');
INSERT INTO `learning_notification` VALUES (204, 111, 1, '3', '1', 205, NULL, '支持一下', '1', '2026-10-30 09:52:15', '2026-10-25 11:18:34');
INSERT INTO `learning_notification` VALUES (205, 111, 106, '3', '1', 201, NULL, '写得很好，学到了', '1', '2026-10-30 09:52:15', '2026-10-25 10:18:34');
INSERT INTO `learning_notification` VALUES (206, 111, 104, '3', '1', 202, NULL, '这篇讲得很清楚，收藏了', '1', '2026-10-30 09:52:15', '2026-10-25 09:18:34');
INSERT INTO `learning_notification` VALUES (207, 111, 1, '3', '1', 203, NULL, '正好在学这块，感谢分享', '1', '2026-10-30 09:52:15', '2026-10-25 08:18:34');
INSERT INTO `learning_notification` VALUES (208, 111, 106, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 07:18:34');
INSERT INTO `learning_notification` VALUES (209, 111, 104, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 06:18:34');
INSERT INTO `learning_notification` VALUES (210, 111, 1, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 05:18:34');
INSERT INTO `learning_notification` VALUES (211, 111, 106, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 04:18:34');
INSERT INTO `learning_notification` VALUES (212, 111, 104, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 03:18:34');
INSERT INTO `learning_notification` VALUES (213, 111, 1, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-25 02:18:34');
INSERT INTO `learning_notification` VALUES (214, 111, 106, '5', '1', 205, NULL, '支持一下', '1', '2026-10-30 09:52:15', '2026-10-25 01:18:34');
INSERT INTO `learning_notification` VALUES (215, 111, 104, '5', '1', 201, NULL, '写得很好，学到了', '1', '2026-10-30 09:52:15', '2026-10-25 00:18:34');
INSERT INTO `learning_notification` VALUES (216, 118, 112, '1', '1', 211, NULL, NULL, '1', '2026-10-30 09:51:15', '2026-10-29 14:27:43');
INSERT INTO `learning_notification` VALUES (217, 118, 112, '2', '1', 211, NULL, NULL, '1', '2026-10-30 09:51:15', '2026-10-29 14:28:32');
INSERT INTO `learning_notification` VALUES (218, 118, 112, '3', '1', 211, NULL, 'test-cmt', '1', '2026-10-30 09:51:15', '2026-10-29 14:30:04');
INSERT INTO `learning_notification` VALUES (219, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 15:47:20');
INSERT INTO `learning_notification` VALUES (220, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 15:47:22');
INSERT INTO `learning_notification` VALUES (221, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 15:47:24');
INSERT INTO `learning_notification` VALUES (222, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 15:47:31');
INSERT INTO `learning_notification` VALUES (223, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 15:49:09');
INSERT INTO `learning_notification` VALUES (224, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 15:49:11');
INSERT INTO `learning_notification` VALUES (225, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 15:54:04');
INSERT INTO `learning_notification` VALUES (226, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 15:57:42');
INSERT INTO `learning_notification` VALUES (227, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 15:57:53');
INSERT INTO `learning_notification` VALUES (228, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:03:40');
INSERT INTO `learning_notification` VALUES (229, 111, 112, '2', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:03:53');
INSERT INTO `learning_notification` VALUES (230, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:04:05');
INSERT INTO `learning_notification` VALUES (231, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:05:32');
INSERT INTO `learning_notification` VALUES (232, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:09:43');
INSERT INTO `learning_notification` VALUES (233, 111, 112, '2', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:09:54');
INSERT INTO `learning_notification` VALUES (234, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:10:22');
INSERT INTO `learning_notification` VALUES (235, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:20:04');
INSERT INTO `learning_notification` VALUES (236, 111, 112, '2', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:20:24');
INSERT INTO `learning_notification` VALUES (237, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:20:30');
INSERT INTO `learning_notification` VALUES (238, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:21:03');
INSERT INTO `learning_notification` VALUES (239, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:21:25');
INSERT INTO `learning_notification` VALUES (240, 111, 112, '2', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:21:32');
INSERT INTO `learning_notification` VALUES (241, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:23:01');
INSERT INTO `learning_notification` VALUES (242, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:23:06');
INSERT INTO `learning_notification` VALUES (243, 111, 112, '2', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:23:14');
INSERT INTO `learning_notification` VALUES (244, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:25:22');
INSERT INTO `learning_notification` VALUES (245, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:25:24');
INSERT INTO `learning_notification` VALUES (246, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:25:40');
INSERT INTO `learning_notification` VALUES (247, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:25:43');
INSERT INTO `learning_notification` VALUES (248, 111, 112, '2', '3', 202, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:25:44');
INSERT INTO `learning_notification` VALUES (249, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:29:56');
INSERT INTO `learning_notification` VALUES (250, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:30:05');
INSERT INTO `learning_notification` VALUES (251, 111, 112, '2', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:30:05');
INSERT INTO `learning_notification` VALUES (252, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 16:30:28');
INSERT INTO `learning_notification` VALUES (253, 111, 115, '2', '3', 201, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-29 17:08:29');
INSERT INTO `learning_notification` VALUES (254, 111, 118, '4', NULL, NULL, NULL, NULL, '1', '2026-10-30 09:52:15', '2026-10-30 09:51:30');
INSERT INTO `learning_notification` VALUES (255, 112, 111, '1', '1', 214, NULL, NULL, '1', '2026-11-06 16:42:56', '2026-10-30 10:06:29');
INSERT INTO `learning_notification` VALUES (256, 112, 106, '1', '1', 214, NULL, NULL, '1', '2026-11-06 17:12:46', '2026-10-30 10:06:29');
INSERT INTO `learning_notification` VALUES (257, 118, 106, '1', '1', 211, NULL, NULL, '0', NULL, '2026-10-30 10:06:29');
INSERT INTO `learning_notification` VALUES (258, 112, 109, '1', '1', 214, NULL, NULL, '1', '2026-11-06 16:37:23', '2026-10-30 10:06:29');
INSERT INTO `learning_notification` VALUES (259, 118, 109, '1', '1', 211, NULL, NULL, '0', NULL, '2026-10-30 10:06:29');
INSERT INTO `learning_notification` VALUES (260, 1, 109, '1', '1', 101, NULL, NULL, '0', NULL, '2026-10-30 10:06:29');
INSERT INTO `learning_notification` VALUES (261, 118, 111, '4', NULL, NULL, NULL, NULL, '0', NULL, '2026-10-30 15:24:24');
INSERT INTO `learning_notification` VALUES (262, 111, 112, '1', '3', 203, NULL, NULL, '1', '2026-11-04 09:40:24', '2026-11-02 09:23:11');
INSERT INTO `learning_notification` VALUES (263, 111, 112, '3', '3', 203, NULL, '1¹1', '1', '2026-11-04 09:40:24', '2026-11-02 09:23:20');
INSERT INTO `learning_notification` VALUES (264, 111, 112, '1', '3', 202, NULL, NULL, '1', '2026-11-04 09:40:24', '2026-11-02 09:23:46');
INSERT INTO `learning_notification` VALUES (265, 111, 112, '2', '3', 202, NULL, NULL, '1', '2026-11-04 09:40:24', '2026-11-02 09:23:46');
INSERT INTO `learning_notification` VALUES (266, 118, 115, '5', '2', 201, 140, '11111111', '0', NULL, '2026-11-02 09:31:26');
INSERT INTO `learning_notification` VALUES (267, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-11-04 09:40:24', '2026-11-02 09:45:41');
INSERT INTO `learning_notification` VALUES (268, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-11-04 09:40:24', '2026-11-02 09:45:43');
INSERT INTO `learning_notification` VALUES (269, 111, 112, '3', '3', 201, 142, '8888', '1', '2026-11-04 09:40:24', '2026-11-02 09:45:55');
INSERT INTO `learning_notification` VALUES (270, 111, 112, '3', '3', 201, NULL, '666', '1', '2026-11-04 09:39:58', '2026-11-02 09:46:08');
INSERT INTO `learning_notification` VALUES (271, 115, 112, '4', NULL, NULL, NULL, NULL, '1', '2026-11-11 17:58:55', '2026-11-02 09:49:56');
INSERT INTO `learning_notification` VALUES (273, 112, 115, '4', NULL, NULL, NULL, NULL, '1', '2026-11-06 16:37:39', '2026-11-02 14:04:36');
INSERT INTO `learning_notification` VALUES (274, 112, 115, '1', '1', 214, NULL, NULL, '1', '2026-11-06 16:37:19', '2026-11-02 14:04:43');
INSERT INTO `learning_notification` VALUES (275, 112, 115, '1', '1', 214, NULL, NULL, '1', '2026-11-06 16:37:10', '2026-11-02 14:04:53');
INSERT INTO `learning_notification` VALUES (276, 112, 115, '2', '1', 214, NULL, NULL, '1', '2026-11-06 16:37:29', '2026-11-02 14:04:55');
INSERT INTO `learning_notification` VALUES (277, 112, 115, '3', '1', 214, NULL, '00000', '1', '2026-11-06 16:37:32', '2026-11-02 14:05:04');
INSERT INTO `learning_notification` VALUES (278, 112, 115, '3', '1', 214, NULL, '11111', '1', '2026-11-06 16:37:35', '2026-11-02 14:05:16');
INSERT INTO `learning_notification` VALUES (279, 115, 111, '5', '2', 202, 150, '555', '1', '2026-11-11 17:58:42', '2026-11-04 14:13:53');
INSERT INTO `learning_notification` VALUES (280, 111, 115, '1', '3', 203, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 09:06:45');
INSERT INTO `learning_notification` VALUES (281, 111, 112, '2', '1', 223, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 09:39:46');
INSERT INTO `learning_notification` VALUES (282, 111, 112, '2', '1', 223, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 09:39:50');
INSERT INTO `learning_notification` VALUES (283, 111, 112, '2', '1', 223, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 09:40:02');
INSERT INTO `learning_notification` VALUES (284, 111, 112, '2', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 09:40:33');
INSERT INTO `learning_notification` VALUES (285, 111, 112, '2', '3', 203, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 09:51:38');
INSERT INTO `learning_notification` VALUES (286, 111, 112, '2', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 09:51:43');
INSERT INTO `learning_notification` VALUES (287, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 09:51:48');
INSERT INTO `learning_notification` VALUES (288, 111, 112, '1', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 09:54:29');
INSERT INTO `learning_notification` VALUES (289, 111, 115, '1', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 10:49:29');
INSERT INTO `learning_notification` VALUES (290, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 11:43:02');
INSERT INTO `learning_notification` VALUES (291, 111, 112, '1', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 11:43:37');
INSERT INTO `learning_notification` VALUES (292, 118, 112, '2', '1', 211, NULL, NULL, '0', NULL, '2026-11-06 14:29:08');
INSERT INTO `learning_notification` VALUES (293, 118, 112, '1', '1', 211, NULL, NULL, '0', NULL, '2026-11-06 14:29:09');
INSERT INTO `learning_notification` VALUES (294, 111, 112, '1', '1', 223, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 14:29:35');
INSERT INTO `learning_notification` VALUES (295, 118, 112, '3', '1', 211, 152, 'zdjd', '0', NULL, '2026-11-06 14:34:35');
INSERT INTO `learning_notification` VALUES (296, 1, 112, '3', '1', 101, 153, '1111', '0', NULL, '2026-11-06 14:56:35');
INSERT INTO `learning_notification` VALUES (297, 111, 112, '1', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 15:13:52');
INSERT INTO `learning_notification` VALUES (298, 111, 112, '2', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 15:13:54');
INSERT INTO `learning_notification` VALUES (299, 111, 112, '1', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 15:16:11');
INSERT INTO `learning_notification` VALUES (300, 111, 112, '2', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 15:16:12');
INSERT INTO `learning_notification` VALUES (301, 111, 112, '1', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 15:16:14');
INSERT INTO `learning_notification` VALUES (302, 111, 112, '2', '3', 202, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-06 15:16:15');
INSERT INTO `learning_notification` VALUES (303, 111, 112, '3', '1', 201, 154, '666', '1', '2026-11-17 16:21:46', '2026-11-06 15:19:44');
INSERT INTO `learning_notification` VALUES (304, 111, 112, '3', '3', 203, NULL, '666', '1', '2026-11-17 16:21:46', '2026-11-06 15:20:50');
INSERT INTO `learning_notification` VALUES (305, 111, 112, '3', '1', 223, NULL, '1', '1', '2026-11-17 16:21:46', '2026-11-06 15:41:09');
INSERT INTO `learning_notification` VALUES (306, 111, 112, '3', '3', 203, NULL, 'haoma', '1', '2026-11-17 16:21:46', '2026-11-06 16:08:39');
INSERT INTO `learning_notification` VALUES (307, 111, 112, '3', '3', 203, NULL, 'hiazai', '1', '2026-11-17 16:21:46', '2026-11-06 16:08:49');
INSERT INTO `learning_notification` VALUES (308, 118, 112, '5', '3', 201, 160, '1111111111 1111111111111111111111', '0', NULL, '2026-11-06 16:21:40');
INSERT INTO `learning_notification` VALUES (309, 111, 112, '3', '3', 201, 160, '1111111111 1111111111111111111111', '1', '2026-11-17 16:21:46', '2026-11-06 16:21:40');
INSERT INTO `learning_notification` VALUES (310, 111, 112, '3', '1', 205, NULL, '111111111111111111111111', '1', '2026-11-17 16:21:46', '2026-11-06 16:23:00');
INSERT INTO `learning_notification` VALUES (311, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-09 10:25:50');
INSERT INTO `learning_notification` VALUES (312, 111, 112, '2', '3', 201, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-09 10:31:14');
INSERT INTO `learning_notification` VALUES (313, 111, 112, '1', '3', 201, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-09 10:36:46');
INSERT INTO `learning_notification` VALUES (314, 111, 112, '3', '3', 201, NULL, '12345', '1', '2026-11-17 16:21:46', '2026-11-09 10:49:40');
INSERT INTO `learning_notification` VALUES (315, 111, 115, '1', '3', 203, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-11 16:41:27');
INSERT INTO `learning_notification` VALUES (316, 111, 115, '1', '3', 203, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-11 17:29:17');
INSERT INTO `learning_notification` VALUES (317, 1, 121, '3', '1', 101, NULL, '线上测试评论', '0', NULL, '2026-11-12 14:43:50');
INSERT INTO `learning_notification` VALUES (318, 1, 121, '3', '1', 101, NULL, '线上测试回复', '0', NULL, '2026-11-12 14:44:05');
INSERT INTO `learning_notification` VALUES (319, 111, 112, '2', '1', 201, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-13 18:22:07');
INSERT INTO `learning_notification` VALUES (320, 111, 112, '1', '1', 201, NULL, NULL, '1', '2026-11-17 16:21:46', '2026-11-13 18:22:11');
INSERT INTO `learning_notification` VALUES (321, 111, 112, '3', '1', 223, NULL, '棒棒棒棒', '1', '2026-11-17 16:21:46', '2026-11-17 15:43:08');
INSERT INTO `learning_notification` VALUES (322, 112, 111, '1', '1', 214, NULL, NULL, '1', '2026-11-17 16:15:06', '2026-11-17 16:12:59');
INSERT INTO `learning_notification` VALUES (323, 112, 111, '2', '1', 214, NULL, NULL, '1', '2026-11-17 16:15:17', '2026-11-17 16:13:05');
INSERT INTO `learning_notification` VALUES (324, 111, 112, '2', '3', 201, NULL, NULL, '0', NULL, '2026-11-17 17:17:58');
INSERT INTO `learning_notification` VALUES (325, 106, 112, '4', NULL, NULL, NULL, NULL, '0', NULL, '2026-11-18 10:46:31');
INSERT INTO `learning_notification` VALUES (332, 118, 112, '5', '3', 201, 175, '111111', '0', NULL, '2026-11-18 13:48:46');
INSERT INTO `learning_notification` VALUES (333, 111, 112, '3', '3', 201, 175, '111111', '0', NULL, '2026-11-18 13:48:46');
INSERT INTO `learning_notification` VALUES (338, 111, 112, '3', '1', 205, NULL, '我是大帅比', '0', NULL, '2026-11-18 16:04:40');
INSERT INTO `learning_notification` VALUES (339, 118, 112, '5', '1', 205, NULL, '你是不是ly', '0', NULL, '2026-11-18 16:04:53');
INSERT INTO `learning_notification` VALUES (340, 111, 112, '3', '1', 205, NULL, '你是不是ly', '0', NULL, '2026-11-18 16:04:53');
INSERT INTO `learning_notification` VALUES (341, 111, 112, '1', '1', 205, NULL, NULL, '0', NULL, '2026-11-18 16:05:07');
INSERT INTO `learning_notification` VALUES (342, 111, 112, '2', '1', 205, NULL, NULL, '0', NULL, '2026-11-18 16:05:10');

-- ----------------------------
-- Table structure for learning_points_account
-- ----------------------------
DROP TABLE IF EXISTS `learning_points_account`;
CREATE TABLE `learning_points_account`  (
  `user_id` bigint NOT NULL COMMENT '用户ID（sys_user.user_id），一个用户一行',
  `balance` int NOT NULL DEFAULT 0 COMMENT '积分余额（页面上的\"我的积分/总积分\"，兑换会扣减）',
  `total_earned` int NOT NULL DEFAULT 0 COMMENT '历史累计获得（只增，备查用，不参与展示口径）',
  `ad_free_expire_time` datetime NULL DEFAULT NULL COMMENT '免广告权益到期时间（null 或已过去 = 无权益）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分账户（余额）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_points_account
-- ----------------------------
INSERT INTO `learning_points_account` VALUES (111, 56, 56, '2026-11-10 16:55:58', '2026-10-27 10:00:39', '2026-11-18 14:35:13');
INSERT INTO `learning_points_account` VALUES (112, 127, 137, '2026-11-18 22:46:52', '2026-10-20 14:27:05', '2026-11-18 22:16:52');
INSERT INTO `learning_points_account` VALUES (115, 9, 19, '2026-11-02 14:36:11', '2026-10-28 11:45:16', '2026-11-18 14:29:12');
INSERT INTO `learning_points_account` VALUES (116, 0, 0, NULL, '2026-10-23 10:49:03', '2026-10-23 10:49:03');
INSERT INTO `learning_points_account` VALUES (118, 3, 3, NULL, '2026-10-27 17:57:19', '2026-11-11 10:32:28');
INSERT INTO `learning_points_account` VALUES (121, 16, 16, NULL, '2026-11-12 14:42:30', '2026-11-12 14:43:50');
INSERT INTO `learning_points_account` VALUES (122, 0, 0, NULL, '2026-11-18 11:38:07', '2026-11-18 11:38:07');
INSERT INTO `learning_points_account` VALUES (126, 6, 6, NULL, '2026-11-17 15:52:38', '2026-11-18 11:47:54');
INSERT INTO `learning_points_account` VALUES (128, 1, 1, NULL, '2026-11-18 16:11:22', '2026-11-18 16:11:23');

-- ----------------------------
-- Table structure for learning_points_log
-- ----------------------------
DROP TABLE IF EXISTS `learning_points_log`;
CREATE TABLE `learning_points_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（sys_user.user_id）',
  `change_amount` int NOT NULL COMMENT '变动值（签到为正、兑换为负）',
  `balance` int NOT NULL COMMENT '变动后的余额快照（任意一条都能看出当时余额，不必重放全表）',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型：checkin 签到 / exchange 兑换 / adjust 手工调整',
  `ref_id` bigint NULL DEFAULT NULL COMMENT '关联业务ID（签到记录 checkin_id 等）',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_points_log_user`(`user_id` ASC, `log_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 126 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_points_log
-- ----------------------------
INSERT INTO `learning_points_log` VALUES (67, 111, 5, 5, 'watchCourse', 201, '观看课程小节满 30 秒', '2026-11-03 20:00:00');
INSERT INTO `learning_points_log` VALUES (68, 111, 5, 10, 'watchPost', 205, '观看帖子满 30 秒', '2026-11-04 19:30:00');
INSERT INTO `learning_points_log` VALUES (69, 111, 1, 11, 'checkin', NULL, '每日签到（连续第1天）', '2026-11-05 10:00:00');
INSERT INTO `learning_points_log` VALUES (70, 111, 2, 13, 'checkin', NULL, '每日签到（连续第2天）', '2026-11-06 10:00:00');
INSERT INTO `learning_points_log` VALUES (71, 111, 3, 16, 'checkin', NULL, '每日签到（连续第3天）', '2026-11-07 10:00:00');
INSERT INTO `learning_points_log` VALUES (72, 111, 4, 20, 'checkin', NULL, '每日签到（连续第4天）', '2026-11-08 10:00:00');
INSERT INTO `learning_points_log` VALUES (73, 111, 5, 25, 'checkin', NULL, '每日签到（连续第5天）', '2026-11-09 10:00:00');
INSERT INTO `learning_points_log` VALUES (74, 111, 6, 31, 'checkin', NULL, '每日签到（连续第6天）', '2026-11-10 10:00:00');
INSERT INTO `learning_points_log` VALUES (76, 111, 10, 41, 'watchAd', NULL, '观看广告奖励', '2026-11-11 08:03:22');
INSERT INTO `learning_points_log` VALUES (77, 112, 5, 5, 'watchCourse', 202, '观看课程小节满 30 秒', '2026-11-04 20:10:00');
INSERT INTO `learning_points_log` VALUES (78, 112, 1, 6, 'checkin', NULL, '每日签到（连续第1天）', '2026-11-08 09:10:00');
INSERT INTO `learning_points_log` VALUES (79, 112, 2, 8, 'checkin', NULL, '每日签到（连续第2天）', '2026-11-09 09:10:00');
INSERT INTO `learning_points_log` VALUES (80, 112, 3, 11, 'checkin', NULL, '每日签到（连续第3天）', '2026-11-10 09:10:00');
INSERT INTO `learning_points_log` VALUES (81, 112, 10, 21, 'watchAd', NULL, '观看广告奖励', '2026-11-11 06:03:22');
INSERT INTO `learning_points_log` VALUES (82, 115, 1, 1, 'checkin', NULL, '每日签到（连续第1天）', '2026-11-07 21:05:00');
INSERT INTO `learning_points_log` VALUES (83, 115, 2, 3, 'checkin', NULL, '每日签到（连续第2天）', '2026-11-08 21:05:00');
INSERT INTO `learning_points_log` VALUES (85, 115, 10, 13, 'watchAd', NULL, '观看广告奖励', '2026-11-10 11:03:23');
INSERT INTO `learning_points_log` VALUES (86, 118, 1, 1, 'checkin', NULL, '每日签到（连续第1天）', '2026-11-07 20:00:00');
INSERT INTO `learning_points_log` VALUES (87, 118, 2, 3, 'checkin', NULL, '每日签到（连续第2天）', '2026-11-08 20:00:00');
INSERT INTO `learning_points_log` VALUES (90, 111, 7, 48, 'checkin', NULL, '每日签到（连续第7天）', '2026-11-11 11:07:30');
INSERT INTO `learning_points_log` VALUES (91, 115, 5, 18, 'checkin', 50, '每日签到（连续第1天）', '2026-11-11 14:22:47');
INSERT INTO `learning_points_log` VALUES (92, 112, 12, 33, 'checkin', 51, '每日签到（连续第4天）', '2026-11-11 14:35:35');
INSERT INTO `learning_points_log` VALUES (93, 112, 5, 38, 'checkin', 52, '每日签到（连续第5天）', '2026-11-12 10:26:07');
INSERT INTO `learning_points_log` VALUES (94, 121, 1, 1, 'checkin', 53, '每日签到（连续第1天）', '2026-11-12 14:43:50');
INSERT INTO `learning_points_log` VALUES (95, 121, 5, 6, 'watchCourse', 201, '观看课程小节满 30 秒', '2026-11-12 14:43:50');
INSERT INTO `learning_points_log` VALUES (96, 121, 10, 16, 'watchAd', NULL, '观看广告奖励', '2026-11-12 14:43:50');
INSERT INTO `learning_points_log` VALUES (97, 112, 6, 44, 'checkin', 55, '每日签到（连续第6天）', '2026-11-13 09:03:21');
INSERT INTO `learning_points_log` VALUES (98, 112, 5, 49, 'watchPost', 203, '观看帖子满 30 秒', '2026-11-13 11:06:31');
INSERT INTO `learning_points_log` VALUES (99, 112, 5, 54, 'watchCourse', 201, '观看课程小节满 30 秒', '2026-11-13 11:12:08');
INSERT INTO `learning_points_log` VALUES (100, 112, 5, 59, 'watchPost', 223, '观看帖子满 30 秒', '2026-11-13 18:16:30');
INSERT INTO `learning_points_log` VALUES (101, 112, 5, 64, 'watchPost', 201, '观看帖子满 30 秒', '2026-11-13 18:20:42');
INSERT INTO `learning_points_log` VALUES (102, 111, 5, 53, 'watchCourse', 203, '观看课程小节满 30 秒', '2026-11-17 10:56:02');
INSERT INTO `learning_points_log` VALUES (104, 112, 1, 65, 'checkin', 56, '每日签到（连续第1天）', '2026-11-17 15:41:42');
INSERT INTO `learning_points_log` VALUES (105, 112, 5, 70, 'watchPost', 223, '观看帖子满 30 秒', '2026-11-17 15:42:42');
INSERT INTO `learning_points_log` VALUES (106, 126, 1, 1, 'checkin', 57, '每日签到（连续第1天）', '2026-11-17 15:52:40');
INSERT INTO `learning_points_log` VALUES (107, 112, 5, 75, 'watchCourse', 203, '观看课程小节满 30 秒', '2026-11-17 16:00:02');
INSERT INTO `learning_points_log` VALUES (108, 112, 5, 80, 'watchCourse', 204, '观看课程小节满 30 秒', '2026-11-17 16:02:42');
INSERT INTO `learning_points_log` VALUES (109, 111, 1, 54, 'checkin', 58, '每日签到（连续第1天）', '2026-11-17 16:18:18');
INSERT INTO `learning_points_log` VALUES (110, 112, 5, 85, 'watchPost', 214, '观看帖子满 30 秒', '2026-11-17 17:48:37');
INSERT INTO `learning_points_log` VALUES (111, 112, 5, 90, 'watchPost', 214, '观看帖子满 30 秒', '2026-11-18 10:30:58');
INSERT INTO `learning_points_log` VALUES (112, 115, -5, 13, 'shopExchange', 1, '兑换商品：平台限定贴纸包', '2026-11-18 11:36:09');
INSERT INTO `learning_points_log` VALUES (113, 112, 2, 92, 'checkin', 59, '每日签到（连续第2天）', '2026-11-18 11:36:53');
INSERT INTO `learning_points_log` VALUES (114, 112, 5, 97, 'watchPost', 223, '观看帖子满 30 秒', '2026-11-18 11:47:43');
INSERT INTO `learning_points_log` VALUES (115, 126, 5, 6, 'watchPost', 223, '观看帖子满 30 秒', '2026-11-18 11:47:54');
INSERT INTO `learning_points_log` VALUES (116, 112, 5, 102, 'watchPost', 211, '观看帖子满 30 秒', '2026-11-18 11:52:47');
INSERT INTO `learning_points_log` VALUES (117, 115, 1, 14, 'checkin', 60, '每日签到（连续第1天）', '2026-11-18 13:59:38');
INSERT INTO `learning_points_log` VALUES (118, 115, -5, 9, 'shopExchange', 2, '兑换商品：平台限定贴纸包', '2026-11-18 14:29:12');
INSERT INTO `learning_points_log` VALUES (119, 111, 2, 56, 'checkin', 61, '每日签到（连续第2天）', '2026-11-18 14:35:13');
INSERT INTO `learning_points_log` VALUES (120, 112, 5, 107, 'watchPost', 205, '观看帖子满 30 秒', '2026-11-18 14:37:52');
INSERT INTO `learning_points_log` VALUES (121, 128, 1, 1, 'checkin', 62, '每日签到（连续第1天）', '2026-11-18 16:11:23');
INSERT INTO `learning_points_log` VALUES (122, 112, 10, 117, 'watchAd', NULL, '观看广告奖励', '2026-11-18 18:17:32');
INSERT INTO `learning_points_log` VALUES (123, 112, 10, 127, 'watchAd', NULL, '观看广告奖励', '2026-11-18 21:54:51');
INSERT INTO `learning_points_log` VALUES (124, 112, 10, 137, 'watchAd', NULL, '观看广告奖励', '2026-11-18 21:55:58');
INSERT INTO `learning_points_log` VALUES (125, 112, -10, 127, 'exchange', NULL, '兑换免广告30 分钟', '2026-11-18 22:16:52');

-- ----------------------------
-- Table structure for learning_points_watch
-- ----------------------------
DROP TABLE IF EXISTS `learning_points_watch`;
CREATE TABLE `learning_points_watch`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `target_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容类型：post / courseVideo',
  `target_id` bigint NOT NULL COMMENT '内容ID：帖子ID / 课程小节ID',
  `award_date` date NOT NULL COMMENT '归属日期（东八区）',
  `watched_seconds` int NOT NULL DEFAULT 0 COMMENT '当天累计观看秒数',
  `awarded` tinyint NOT NULL DEFAULT 0 COMMENT '是否已发分：0否 1是',
  `points` int NOT NULL DEFAULT 0 COMMENT '已发积分',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_target_date`(`user_id` ASC, `target_type` ASC, `target_id` ASC, `award_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 571 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分-内容观看累计与去重' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_points_watch
-- ----------------------------
INSERT INTO `learning_points_watch` VALUES (10, 121, 'courseVideo', 201, '2026-11-12', 60, 1, 5, '2026-11-12 14:43:50', '2026-11-12 14:43:50');
INSERT INTO `learning_points_watch` VALUES (12, 112, 'post', 203, '2026-11-13', 100, 1, 5, '2026-11-13 11:06:09', '2026-11-13 18:15:40');
INSERT INTO `learning_points_watch` VALUES (16, 112, 'courseVideo', 201, '2026-11-13', 124, 1, 5, '2026-11-13 11:10:20', '2026-11-13 11:25:11');
INSERT INTO `learning_points_watch` VALUES (26, 112, 'post', 223, '2026-11-13', 30, 1, 5, '2026-11-13 18:16:30', '2026-11-13 18:16:30');
INSERT INTO `learning_points_watch` VALUES (27, 112, 'post', 201, '2026-11-13', 30, 1, 5, '2026-11-13 18:20:41', '2026-11-13 18:20:42');
INSERT INTO `learning_points_watch` VALUES (28, 111, 'courseVideo', 203, '2026-11-17', 31, 1, 5, '2026-11-17 09:13:52', '2026-11-17 10:56:02');
INSERT INTO `learning_points_watch` VALUES (32, 112, 'post', 223, '2026-11-17', 30, 1, 5, '2026-11-17 15:42:41', '2026-11-17 15:42:42');
INSERT INTO `learning_points_watch` VALUES (33, 112, 'courseVideo', 203, '2026-11-17', 244, 1, 5, '2026-11-17 15:50:26', '2026-11-17 16:13:13');
INSERT INTO `learning_points_watch` VALUES (34, 112, 'courseVideo', 202, '2026-11-17', 15, 0, 0, '2026-11-17 15:52:10', '2026-11-17 15:56:11');
INSERT INTO `learning_points_watch` VALUES (36, 112, 'courseVideo', 201, '2026-11-17', 9, 0, 0, '2026-11-17 15:55:09', '2026-11-17 17:26:39');
INSERT INTO `learning_points_watch` VALUES (40, 112, 'courseVideo', 204, '2026-11-17', 55, 1, 5, '2026-11-17 15:59:29', '2026-11-17 16:03:03');
INSERT INTO `learning_points_watch` VALUES (47, 112, 'post', 214, '2026-11-17', 45, 1, 5, '2026-11-17 16:01:35', '2026-11-17 17:48:41');
INSERT INTO `learning_points_watch` VALUES (50, 112, 'post', 205, '2026-11-17', 1, 0, 0, '2026-11-17 16:01:48', '2026-11-17 16:01:48');
INSERT INTO `learning_points_watch` VALUES (82, 112, 'post', 214, '2026-11-18', 2805, 1, 5, '2026-11-18 10:20:27', '2026-11-18 17:44:52');
INSERT INTO `learning_points_watch` VALUES (88, 112, 'post', 223, '2026-11-18', 4571, 1, 5, '2026-11-18 10:32:38', '2026-11-18 18:01:11');
INSERT INTO `learning_points_watch` VALUES (115, 112, 'post', 205, '2026-11-18', 915, 1, 5, '2026-11-18 10:53:06', '2026-11-18 17:46:57');
INSERT INTO `learning_points_watch` VALUES (117, 126, 'post', 223, '2026-11-18', 821, 1, 5, '2026-11-18 11:47:34', '2026-11-18 12:00:58');
INSERT INTO `learning_points_watch` VALUES (144, 112, 'post', 211, '2026-11-18', 64, 1, 5, '2026-11-18 11:52:11', '2026-11-18 16:04:19');
INSERT INTO `learning_points_watch` VALUES (322, 112, 'post', 204, '2026-11-18', 2, 0, 0, '2026-11-18 14:40:14', '2026-11-18 14:40:14');

-- ----------------------------
-- Table structure for learning_post
-- ----------------------------
DROP TABLE IF EXISTS `learning_post`;
CREATE TABLE `learning_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `post_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '帖子标题',
  `category_id` bigint NULL DEFAULT NULL COMMENT '所属类别ID（逻辑关联 learning_category.category_id，category_type=article）',
  `user_id` bigint NOT NULL COMMENT '作者用户ID（逻辑关联 sys_user.user_id）',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '正文（Markdown 原文，图片以 ![](/profile/...) 内联）',
  `like_count` int NOT NULL DEFAULT 0,
  `favorite_count` int NOT NULL DEFAULT 0,
  `comment_count` int NULL DEFAULT 0 COMMENT '评论数',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '状态（0已发布 1草稿 2已下架 3待审核 4已驳回）',
  `is_featured` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '精华标志（0否 1是，管理员在审核时或编辑时指定）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '最近一次审核备注（驳回原因；通过时可写说明；留空即清空）',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '阅读数（首次阅读时 +1，由观看历史维护）',
  PRIMARY KEY (`post_id`) USING BTREE,
  INDEX `idx_post_category`(`category_id` ASC, `del_flag` ASC) USING BTREE,
  INDEX `idx_post_user`(`user_id` ASC, `del_flag` ASC) USING BTREE,
  INDEX `idx_post_status`(`status` ASC, `del_flag` ASC) USING BTREE,
  CONSTRAINT `chk_post_favorite_count` CHECK (`favorite_count` >= 0),
  CONSTRAINT `chk_post_like_count` CHECK (`like_count` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 231 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台社区帖子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_post
-- ----------------------------
INSERT INTO `learning_post` VALUES (100, '回归测试帖', 100, 106, '测试内容', 0, 0, 0, '0', '0', '2', '13900001111', '2026-10-14 11:27:41', '', '2026-10-14 11:29:19', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (101, '管理员的帖子改', 100, 1, '改后内容', 0, 0, 1, '0', '0', '0', 'admin', '2026-10-14 11:43:20', 'admin', '2026-10-19 14:08:42', NULL, NULL, 1);
INSERT INTO `learning_post` VALUES (102, '管理员的草稿', 100, 1, '', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-14 11:43:25', '', '2026-10-14 11:45:16', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (103, '139的帖子改', 100, 106, '我改的', 0, 0, 0, '0', '0', '2', '13900001111', '2026-10-14 11:49:50', '13900001111', '2026-10-14 11:52:27', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (106, '边界草稿', 100, 1, '', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-15 11:23:27', '', '2026-10-15 11:27:30', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (108, '搜索测试帖', 100, 1, '搜索测试内容', 0, 0, 0, '0', '0', '2', 'admin', '2026-10-15 16:09:17', '', '2026-10-15 16:12:34', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (109, '搜索草稿帖', 100, 1, '', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-15 16:09:22', '', '2026-10-15 17:56:05', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (110, '审核测试帖', 100, 106, '审核测试内容', 0, 0, 0, '0', '1', '2', '13900001111', '2026-10-15 17:39:34', 'admin', '2026-10-15 17:56:05', NULL, '内容合格通过', 0);
INSERT INTO `learning_post` VALUES (111, '审核驳回帖', 100, 106, '驳回测试内容', 0, 0, 0, '4', '0', '2', '13900001111', '2026-10-15 17:50:01', 'admin', '2026-10-15 17:56:05', NULL, '内容不合规', 0);
INSERT INTO `learning_post` VALUES (113, '提示语回归草稿', 100, 1, '草稿', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-16 14:51:01', '', '2026-10-16 15:04:43', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (119, '笔记草稿测试', 100, 1, '草稿', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-19 11:38:36', '', '2026-10-19 11:51:57', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (201, 'Java 8 Stream 流式编程实践', 100, 111, 'Stream API 的核心用法：filter/map/collect 链式操作、并行流注意事项与常见坑位，让集合处理更简洁高效。', 1, 0, 2, '0', '0', '0', '111', '2026-10-20 14:21:20', '', NULL, NULL, NULL, 2);
INSERT INTO `learning_post` VALUES (202, 'MySQL 索引失效的常见场景', 102, 111, '函数运算、隐式类型转换、前导模糊查询、OR 连接等导致索引失效的典型场景，以及对应的规避写法。', 0, 1, 0, '0', '0', '0', '111', '2026-10-20 14:21:20', '', NULL, NULL, NULL, 1);
INSERT INTO `learning_post` VALUES (203, 'Redis 缓存穿透、击穿与雪崩', 104, 111, '三种缓存异常的成因图解：空值缓存、布隆过滤器、互斥锁与逻辑过期等经典解决方案。', 1, 0, 3, '0', '0', '0', '111', '2026-10-20 14:21:20', '', NULL, NULL, NULL, 2);
INSERT INTO `learning_post` VALUES (204, 'Kafka 消息可靠性保障机制', 106, 111, '生产端 ACK 机制、消费端手动提交、幂等生产者与事务消息，保障消息不丢不重的实践总结。', 1, 1, 0, '0', '0', '0', '111', '2026-10-20 14:21:20', '', NULL, NULL, NULL, 1);
INSERT INTO `learning_post` VALUES (205, '从单体到微服务的架构演进', 108, 111, '服务拆分原则、注册中心选型、网关与配置中心，以及微服务化过程中的常见踩坑记录。', 2, 2, 6, '0', '0', '0', '111', '2026-10-20 14:21:20', 'admin', '2026-11-02 09:35:58', '', NULL, 3);
INSERT INTO `learning_post` VALUES (207, '测试文章-可删除', NULL, 111, '这是给测试练删除用的文章，删除不影响其他数据。', 0, 0, 0, '0', '0', '2', '', '2026-10-23 10:48:23', '', '2026-10-23 11:16:27', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (208, '回归测试文章G1', 100, 111, '测试内容', 0, 0, 0, '3', '0', '2', '13900000001', '2026-10-28 10:46:13', '', '2026-10-28 10:46:15', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (209, '回归测试文章G2', 100, 111, '测试内容', 0, 0, 0, '3', '0', '2', '13900000001', '2026-10-28 10:46:13', '', '2026-10-28 10:46:15', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (210, 'integration test post', 100, 115, 'this is a test content', 0, 0, 0, '4', '0', '2', '13911112222', '2026-10-28 10:46:33', 'admin', '2026-11-02 13:59:34', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (211, '计算机网络3天速成', 108, 118, 'B站搜索计算机网络鱼哥', 2, 1, 1, '0', '1', '0', '13900000009', '2026-10-28 10:54:58', 'admin', '2026-10-28 10:57:37', '', NULL, 5);
INSERT INTO `learning_post` VALUES (212, 'DSH对接验证-可删除', 100, 111, '<p>这是客户端对接 post/add 的验证文章</p>', 0, 0, 0, '3', '0', '2', '13900000001', '2026-10-28 17:11:35', '', '2026-10-28 17:15:30', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (213, 'o_from_android_clientdroid_client', 104, 112, '<p>hello_from_android_client</p>', 0, 0, 0, '3', '0', '2', '13900139001', '2026-10-28 17:15:05', '', '2026-10-28 17:15:28', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (214, 'test', 100, 112, '<p>test</p>', 3, 3, 0, '0', '0', '0', '13900139001', '2026-10-28 17:16:03', 'admin', '2026-10-29 09:28:28', '', NULL, 7);
INSERT INTO `learning_post` VALUES (215, 'test', 100, 112, '<p>test</p>', 0, 0, 0, '4', '0', '2', '13900139001', '2026-10-28 17:33:17', 'admin', '2026-11-02 09:50:54', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (216, '6666', 100, 111, '##11\nDaddy’s dad sad.\n\n##555\nGsgsgsdf./\n\n![](https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/post-1793343193-0_20261030145355A012.jpg)', 0, 0, 0, '0', '1', '2', '13900000001', '2026-10-30 14:54:12', 'admin', '2026-10-30 15:38:07', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (217, '2222', 100, 111, '22222', 0, 0, 0, '0', '0', '2', '13900000001', '2026-10-30 17:51:29', 'admin', '2026-11-02 09:43:37', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (218, '111111', 100, 115, '11111111111111111111111111111111', 0, 0, 0, '0', '0', '2', '13911112222', '2026-11-02 09:33:54', 'admin', '2026-11-02 13:51:41', '', NULL, 0);
INSERT INTO `learning_post` VALUES (219, 'fbfb', 102, 112, 'bujbujbvhb', 0, 0, 0, '0', '0', '2', '13900139001', '2026-11-02 09:48:34', 'admin', '2026-11-02 10:02:19', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (220, '11111', 100, 115, '111', 0, 0, 0, '3', '0', '2', '13911112222', '2026-11-02 14:02:46', '', '2026-11-02 14:03:05', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (221, '话题测试文章-可删', 100, 111, '这是正文第一段，用来测摘要。\n\n![封面](https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/small_20261027155044A001.png)\n\n更多内容……', 0, 0, 0, '0', '0', '2', '13900000001', '2026-11-02 15:49:33', '', NULL, NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (222, '级联测试-可删', 100, 111, '正文', 0, 0, 0, '3', '0', '2', '13900000001', '2026-11-02 15:50:54', '', '2026-11-02 15:50:55', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (223, 'java后端开发', 100, 111, '##非常\n美妙\n##棒\n\n![](https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/04/post-1793775180-0_20261104145335A004.jpg)\n\n![](https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/04/post-1793775214-1_20261104145351A005.jpg)\n\n![](https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/04/post-1793775230-2_20261104145413A006.jpg)', 2, 1, 0, '0', '0', '0', '13900000001', '2026-11-04 14:54:18', 'admin', '2026-11-04 14:54:45', NULL, NULL, 8);
INSERT INTO `learning_post` VALUES (224, 'iOS paging test 1', 100, 115, 'paging verify body 1', 0, 0, 0, '3', '0', '2', '13911112222', '2026-11-06 15:19:57', '', '2026-11-06 16:58:44', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (225, 'iOS paging test 2', 100, 115, 'paging verify body 2', 0, 0, 0, '3', '0', '2', '13911112222', '2026-11-06 15:19:57', '', '2026-11-06 15:35:20', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (226, 'iOS paging test 3', 100, 115, 'paging verify body 3', 0, 0, 0, '3', '0', '2', '13911112222', '2026-11-06 15:19:58', '', '2026-11-06 15:23:03', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (227, '测试', 102, 112, 'vdfgbhfvdb', 0, 0, 0, '3', '0', '0', '13900139001', '2026-11-09 11:16:57', '', NULL, NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (228, '线上测试-话题挂载', 100, 121, '线上部署后功能验证用帖', 0, 0, 0, '3', '0', '0', '13900009999', '2026-11-12 14:43:49', '', NULL, NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (229, '正常测试标题', 100, 118, '正常内容，没有违禁词', 0, 0, 0, '3', '0', '2', '13900000009', '2026-11-18 11:48:18', '', '2026-11-18 11:48:30', NULL, NULL, 0);
INSERT INTO `learning_post` VALUES (230, '测试违禁词标题', 100, 118, '测试 违禁 词', 0, 0, 0, '3', '0', '2', '13900000009', '2026-11-18 11:48:30', '', '2026-11-18 11:48:30', NULL, NULL, 0);

-- ----------------------------
-- Table structure for learning_post_topic
-- ----------------------------
DROP TABLE IF EXISTS `learning_post_topic`;
CREATE TABLE `learning_post_topic`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `post_id` bigint NOT NULL COMMENT '文章ID（逻辑关联 learning_post.post_id）',
  `topic_id` bigint NOT NULL COMMENT '话题ID（逻辑关联 learning_topic.topic_id）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '关联时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_post_topic`(`post_id` ASC, `topic_id` ASC) USING BTREE,
  INDEX `idx_topic`(`topic_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章-话题关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_post_topic
-- ----------------------------
INSERT INTO `learning_post_topic` VALUES (6, 223, 4, '2026-11-04 14:54:18');
INSERT INTO `learning_post_topic` VALUES (7, 228, 1, '2026-11-12 14:43:49');
INSERT INTO `learning_post_topic` VALUES (8, 228, 2, '2026-11-12 14:43:49');

-- ----------------------------
-- Table structure for learning_sensitive_word
-- ----------------------------
DROP TABLE IF EXISTS `learning_sensitive_word`;
CREATE TABLE `learning_sensitive_word`  (
  `word_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `word` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '违禁词',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`word_id`) USING BTREE,
  UNIQUE INDEX `uk_sensitive_word`(`word` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '违禁词库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_sensitive_word
-- ----------------------------
INSERT INTO `learning_sensitive_word` VALUES (1, '赌博', '0', '基础词', 'admin', '2026-11-18 11:43:40', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (2, '诈骗', '0', '基础词', 'admin', '2026-11-18 11:43:40', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (3, '代考', '0', '基础词', 'admin', '2026-11-18 11:43:40', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (4, '刷单', '0', '基础词', 'admin', '2026-11-18 11:43:40', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (5, '外挂', '0', '基础词', 'admin', '2026-11-18 11:43:40', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (7, '加微信', '0', '基础词库', 'admin', '2026-11-19 09:18:48', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (8, '加QQ', '0', '基础词库', 'admin', '2026-11-19 09:18:48', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (9, '扫码加群', '0', '基础词库', 'admin', '2026-11-19 09:18:48', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (10, '兼职日结', '0', '基础词库', 'admin', '2026-11-19 09:18:48', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (11, '高薪兼职', '0', '基础词库', 'admin', '2026-11-19 09:18:48', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (12, '刷单返利', '0', '基础词库', 'admin', '2026-11-19 09:18:48', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (13, '点击链接领取', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (14, '推广返利', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (16, '博彩', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (18, '洗钱', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (19, '套现', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (21, '代写论文', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (23, '破解版', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (24, '枪支', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (25, '毒品', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (26, '迷药', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (27, '傻逼', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (28, '脑残', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (29, '智障', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (30, '废物', '0', '基础词库', 'admin', '2026-11-19 09:18:49', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (31, '滚蛋', '0', '基础词库', 'admin', '2026-11-19 09:18:50', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (32, '裸聊', '0', '基础词库', 'admin', '2026-11-19 09:18:50', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (33, '约炮', '0', '基础词库', 'admin', '2026-11-19 09:18:50', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (34, '招嫖', '0', '基础词库', 'admin', '2026-11-19 09:18:50', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (35, '传销', '0', '基础词库', 'admin', '2026-11-19 09:18:50', NULL, NULL);
INSERT INTO `learning_sensitive_word` VALUES (36, '发票代开', '0', '基础词库', 'admin', '2026-11-19 09:18:50', NULL, NULL);

-- ----------------------------
-- Table structure for learning_shop_address
-- ----------------------------
DROP TABLE IF EXISTS `learning_shop_address`;
CREATE TABLE `learning_shop_address`  (
  `address_id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（sys_user.user_id）',
  `receiver_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收货人',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收货人手机号',
  `detail_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '详细地址',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '默认地址（1默认；NULL非默认）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`address_id`) USING BTREE,
  UNIQUE INDEX `uk_shop_address_default`(`user_id` ASC, `is_default` ASC) USING BTREE,
  INDEX `idx_shop_address_user`(`user_id` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分商城-收货地址' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_shop_address
-- ----------------------------
INSERT INTO `learning_shop_address` VALUES (1, 115, 'Zheng San', '13911112222', 'Zhenjiang Hangzhou Xueyuan Road 8', '1', '0', '2026-11-18 11:27:26', '2026-11-18 16:16:18');

-- ----------------------------
-- Table structure for learning_shop_category
-- ----------------------------
DROP TABLE IF EXISTS `learning_shop_category`;
CREATE TABLE `learning_shop_category`  (
  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`category_id`) USING BTREE,
  INDEX `idx_shop_category_status`(`status` ASC, `del_flag` ASC, `order_num` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分商城-商品分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_shop_category
-- ----------------------------
INSERT INTO `learning_shop_category` VALUES (1, '数码周边', 1, '0', '0', 'admin', '2026-11-18 10:48:58', '', NULL, NULL);
INSERT INTO `learning_shop_category` VALUES (2, '学习文具', 2, '0', '0', 'admin', '2026-11-18 10:48:58', '', NULL, NULL);
INSERT INTO `learning_shop_category` VALUES (3, '生活好物', 3, '0', '0', 'admin', '2026-11-18 10:48:58', '', NULL, NULL);
INSERT INTO `learning_shop_category` VALUES (4, '图书饮品', 4, '0', '0', 'admin', '2026-11-18 10:48:58', '', NULL, NULL);
INSERT INTO `learning_shop_category` VALUES (5, '测试分类A改', 10, '0', '2', 'admin', '2026-11-18 14:24:51', 'admin', '2026-11-18 14:25:16', '自动化测试-已修改');

-- ----------------------------
-- Table structure for learning_shop_order
-- ----------------------------
DROP TABLE IF EXISTS `learning_shop_order`;
CREATE TABLE `learning_shop_order`  (
  `order_id` bigint NOT NULL AUTO_INCREMENT COMMENT '兑换记录ID',
  `redemption_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '兑换码（全局唯一）',
  `user_id` bigint NOT NULL COMMENT '用户ID（sys_user.user_id）',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称快照',
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品封面快照',
  `points_cost` int NOT NULL COMMENT '消耗积分快照',
  `create_time` datetime NULL DEFAULT NULL COMMENT '兑换时间',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `uk_shop_order_code`(`redemption_code` ASC) USING BTREE,
  INDEX `idx_shop_order_user`(`user_id` ASC, `order_id` ASC) USING BTREE,
  INDEX `idx_shop_order_product`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分商城-兑换记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_shop_order
-- ----------------------------
INSERT INTO `learning_shop_order` VALUES (1, 'SHOPMELGKD2X8Q7M', 115, 12, '平台限定贴纸包', NULL, 5, '2026-11-18 11:36:09');
INSERT INTO `learning_shop_order` VALUES (2, 'SHOPN82K4R7P6SC3', 115, 12, '平台限定贴纸包', NULL, 5, '2026-11-18 14:29:12');

-- ----------------------------
-- Table structure for learning_shop_product
-- ----------------------------
DROP TABLE IF EXISTS `learning_shop_product`;
CREATE TABLE `learning_shop_product`  (
  `product_id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `category_id` bigint NOT NULL COMMENT '分类ID（learning_shop_category.category_id）',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品封面（相对路径或完整 OSS 地址）',
  `points_price` int NOT NULL DEFAULT 0 COMMENT '兑换所需积分',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存',
  `sold_count` int NOT NULL DEFAULT 0 COMMENT '已兑换数量',
  `description` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品描述',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0上架 1下架）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`product_id`) USING BTREE,
  INDEX `idx_shop_product_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_shop_product_status`(`status` ASC, `del_flag` ASC, `order_num` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分商城-商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_shop_product
-- ----------------------------
INSERT INTO `learning_shop_product` VALUES (1, 1, '无线蓝牙耳机', 'http://43.142.9.214/oss-preview/upload/2026/11/18/OIP_20261118113941A002.jpg', 2600, 20, 128, '轻量化半入耳设计，续航 20 小时，学习通勤两不误。', 1, '0', '0', 'admin', '2026-11-18 10:49:22', 'admin', '2026-11-18 11:39:44', '');
INSERT INTO `learning_shop_product` VALUES (2, 1, '桌面学习台灯', NULL, 2200, 15, 86, '三档色温，无频闪，深夜自习的护眼搭档。', 2, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (3, 3, '保温随行杯', NULL, 1200, 40, 210, '316 不锈钢内胆，一杯热水陪你一整节早八。', 3, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (4, 3, '定制帆布托特包', NULL, 800, 60, 45, '加厚帆布，装得下教材和电脑，也装得下周末。', 4, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (5, 2, '中性笔书写礼盒', NULL, 600, 100, 320, '0.5mm 顺滑速干，四色套装，考前刷题不断墨。', 5, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (6, 2, '皮面笔记本套装', NULL, 980, 50, 180, 'A5 皮面本 + 书签，记录课程重点与灵感。', 6, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (7, 4, '经典书单盲盒', NULL, 1500, 30, 60, '从平台推荐书单里随机发一本，拆开才知道的惊喜。', 7, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (8, 1, '蓝牙迷你音箱', NULL, 3000, 10, 25, '掌心大小，宿舍听歌与网课外放都合适。', 8, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (9, 3, '桌面收纳盒', NULL, 700, 80, 96, '分层收纳数据线与文具，桌面瞬间清爽。', 9, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (10, 1, '电子阅读器保护套', NULL, 1800, 25, 33, '磁吸休眠，轻薄防摔，通勤路上安心看。', 10, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (11, 4, '精品咖啡兑换券', NULL, 1000, 200, 260, '校内合作咖啡店中杯任选，提神不将就。', 11, '0', '0', 'admin', '2026-11-18 10:49:22', '', NULL, NULL);
INSERT INTO `learning_shop_product` VALUES (12, 2, '平台限定贴纸包', NULL, 5, 498, 1001, '课程梗贴纸 6 枚装，积分即可带走。', 12, '0', '0', 'admin', '2026-11-18 10:49:22', '', '2026-11-18 14:29:12', NULL);
INSERT INTO `learning_shop_product` VALUES (13, 1, '测试商品A改', '', 120, 8, 0, NULL, 99, '0', '2', 'admin', '2026-11-18 14:25:24', 'admin', '2026-11-18 14:25:44', '自动化测试-已修改');

-- ----------------------------
-- Table structure for learning_short_video
-- ----------------------------
DROP TABLE IF EXISTS `learning_short_video`;
CREATE TABLE `learning_short_video`  (
  `video_id` bigint NOT NULL AUTO_INCREMENT COMMENT '短视频ID',
  `video_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频标题',
  `user_id` bigint NOT NULL COMMENT '上传者用户ID（逻辑关联 sys_user.user_id）',
  `video_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '视频地址（上传返回的相对路径 /profile/...）',
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '封面图片地址（上传返回的相对路径 /profile/...）',
  `intro` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '视频简介',
  `duration` int NULL DEFAULT 0 COMMENT '时长（秒）',
  `view_count` int NULL DEFAULT 0 COMMENT '播放数',
  `like_count` int NOT NULL DEFAULT 0,
  `favorite_count` int NOT NULL DEFAULT 0,
  `comment_count` int NULL DEFAULT 0 COMMENT '评论数',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`video_id`) USING BTREE,
  INDEX `idx_video_user`(`user_id` ASC, `del_flag` ASC) USING BTREE,
  INDEX `idx_video_status`(`status` ASC, `del_flag` ASC) USING BTREE,
  CONSTRAINT `chk_video_favorite_count` CHECK (`favorite_count` >= 0),
  CONSTRAINT `chk_video_like_count` CHECK (`like_count` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 219 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台短视频表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_short_video
-- ----------------------------
INSERT INTO `learning_short_video` VALUES (100, '212312321', 104, '/profile/upload/2026/10/14/反恐精英：全球攻势 2024-12-06 20-06-30_20261014141955A002.mp4', '/profile/upload/2026/10/26/R-C_20261026212151A003.jpg', 'wqqwe', 301, 0, 0, 0, 0, '0', '2', 'eduadmin', '2026-10-14 14:20:12', 'admin', '2026-10-27 11:06:58', '');
INSERT INTO `learning_short_video` VALUES (103, '测试短视频A改', 1, '/profile/upload/2026/10/15/test.mp4', '', '自动化测试', 30, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 10:55:47', 'admin', '2026-10-15 10:59:52', NULL);
INSERT INTO `learning_short_video` VALUES (104, '搜索测试A', 1, '/profile/upload/2026/10/15/sa.mp4', '', '', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 16:09:05', '', '2026-10-15 16:12:30', NULL);
INSERT INTO `learning_short_video` VALUES (105, '搜索测试B', 1, '/profile/upload/2026/10/15/sb.mp4', '', '', 0, 0, 0, 0, 0, '1', '2', 'admin', '2026-10-15 16:09:11', 'admin', '2026-10-15 16:12:30', NULL);
INSERT INTO `learning_short_video` VALUES (106, '孤儿回归', 1, '/profile/upload/2026/10/15/reg.mp4', '', '', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 17:26:06', '', '2026-10-15 17:26:34', NULL);
INSERT INTO `learning_short_video` VALUES (201, 'Sintel 开源短片 · 片段一', 111, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-1.mp4', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/04/sintel_20261104145028A001.jpg', '开源动画短片 Sintel 精彩片段', 52, 10, 3, 2, 11, '0', '0', '111', '2026-10-20 14:21:29', 'admin', '2026-11-04 14:50:31', '');
INSERT INTO `learning_short_video` VALUES (202, 'Sintel 开源短片 · 片段二', 111, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-2.mp4', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/04/sintel_20261104145108A002.jpg', '开源动画短片 Sintel 精彩片段', 52, 14, 2, 2, 1, '0', '0', '111', '2026-10-20 14:21:29', 'admin', '2026-11-04 14:51:08', '');
INSERT INTO `learning_short_video` VALUES (203, 'Sintel 开源短片 · 片段三', 111, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-3.mp4', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/04/sintel_20261104145126A003.jpg', '开源动画短片 Sintel 精彩片段', 52, 11, 3, 2, 0, '0', '0', '111', '2026-10-20 14:21:29', 'admin', '2026-11-04 14:51:26', '');
INSERT INTO `learning_short_video` VALUES (204, '测试短视频01-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-01_20261113140421A001.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-01_20261113140506A002.jpg', '自动化测试数据，本地生成素材', 5, 2, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:05:08', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (205, '测试短视频02-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-02_20261113140748A003.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-02_20261113140802A004.jpg', '自动化测试数据，本地生成素材', 6, 3, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:08:04', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (206, '测试短视频03-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-03_20261113140819A005.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-03_20261113140820A006.jpg', '自动化测试数据，本地生成素材', 4, 3, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:08:22', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (207, '测试短视频04-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-04_20261113140826A007.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-04_20261113140828A008.jpg', '自动化测试数据，本地生成素材', 5, 4, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:08:31', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (208, '测试短视频05-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-05_20261113140842A009.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-05_20261113140844A010.jpg', '自动化测试数据，本地生成素材', 6, 4, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:08:47', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (209, '测试短视频06-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-06_20261113140851A011.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-06_20261113140852A012.jpg', '自动化测试数据，本地生成素材', 4, 4, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:08:54', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (210, '测试短视频07-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-07_20261113140904A013.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-07_20261113140906A014.jpg', '自动化测试数据，本地生成素材', 5, 3, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:09:08', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (211, '测试短视频08-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-08_20261113140913A015.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-08_20261113140915A016.jpg', '自动化测试数据，本地生成素材', 6, 3, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:09:18', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (212, '测试短视频09-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-09_20261113141111A017.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-09_20261113141118A018.jpg', '自动化测试数据，本地生成素材', 4, 4, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:11:21', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (213, '测试短视频10-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-10_20261113141134A019.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-10_20261113141135A020.jpg', '自动化测试数据，本地生成素材', 5, 4, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:11:38', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (214, '测试短视频11-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-11_20261113141207A022.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-11_20261113141152A021.jpg', '自动化测试数据，本地生成素材', 6, 5, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:12:16', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (215, '测试短视频12-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-12_20261113141231A023.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-12_20261113141232A024.jpg', '自动化测试数据，本地生成素材', 4, 5, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:12:34', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (216, '测试短视频13-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-13_20261113141239A025.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-13_20261113141241A026.jpg', '自动化测试数据，本地生成素材', 5, 5, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:12:43', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (217, '测试短视频14-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-14_20261113141257A027.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-14_20261113141259A028.jpg', '自动化测试数据，本地生成素材', 6, 5, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:13:02', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (218, '测试短视频15-功能验证', 1, 'http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-15_20261113141306A029.mp4', 'http://43.142.9.214/oss-preview/upload/2026/11/13/cover-15_20261113141307A030.jpg', '自动化测试数据，本地生成素材', 4, 7, 0, 0, 0, '0', '0', 'admin', '2026-11-13 14:13:09', '', NULL, NULL);

-- ----------------------------
-- Table structure for learning_study_record
-- ----------------------------
DROP TABLE IF EXISTS `learning_study_record`;
CREATE TABLE `learning_study_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID（逻辑关联 sys_user.user_id）',
  `study_date` date NOT NULL COMMENT '学习日期（Asia/Shanghai）',
  `seconds` int NOT NULL DEFAULT 0 COMMENT '当天累计学习秒数',
  `create_time` datetime NULL DEFAULT NULL COMMENT '首次学习时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '最近更新时间',
  `video_seconds` int NOT NULL DEFAULT 0 COMMENT '当天视频学习秒数（课程小节 + 短视频）',
  `article_seconds` int NOT NULL DEFAULT 0 COMMENT '当天文章学习秒数',
  PRIMARY KEY (`record_id`) USING BTREE,
  UNIQUE INDEX `uk_study_user_date`(`user_id` ASC, `study_date` ASC) USING BTREE,
  INDEX `idx_study_date`(`study_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10887 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '学习时长按天汇总' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_study_record
-- ----------------------------
INSERT INTO `learning_study_record` VALUES (1, 111, '2026-11-02', 1320, '2026-11-02 09:37:57', '2026-11-02 10:53:20', 1320, 0);
INSERT INTO `learning_study_record` VALUES (6, 111, '2026-11-01', 2700, '2026-11-02 09:38:19', '2026-11-02 09:38:19', 2700, 0);
INSERT INTO `learning_study_record` VALUES (7, 111, '2026-10-31', 1800, '2026-11-02 09:38:19', '2026-11-02 09:38:19', 1800, 0);
INSERT INTO `learning_study_record` VALUES (8, 111, '2026-10-30', 3600, '2026-11-02 09:38:19', '2026-11-02 09:38:19', 3600, 0);
INSERT INTO `learning_study_record` VALUES (17, 111, '2026-11-04', 121, '2026-11-04 12:19:22', '2026-11-04 14:54:53', 121, 0);
INSERT INTO `learning_study_record` VALUES (35, 115, '2026-11-05', 5827, '2026-11-05 14:32:46', '2026-11-05 20:56:43', 5827, 0);
INSERT INTO `learning_study_record` VALUES (422, 115, '2026-11-06', 3574, '2026-11-06 09:06:37', '2026-11-06 21:51:04', 3426, 0);
INSERT INTO `learning_study_record` VALUES (675, 115, '2026-11-11', 2025, '2026-11-11 14:10:40', '2026-11-11 22:10:06', 0, 0);
INSERT INTO `learning_study_record` VALUES (847, 112, '2026-11-13', 124, '2026-11-13 11:10:18', '2026-11-13 11:25:11', 0, 0);
INSERT INTO `learning_study_record` VALUES (856, 111, '2026-11-17', 134, '2026-11-17 09:12:29', '2026-11-17 16:18:08', 0, 0);
INSERT INTO `learning_study_record` VALUES (888, 112, '2026-11-17', 323, '2026-11-17 15:50:25', '2026-11-17 17:26:39', 0, 0);
INSERT INTO `learning_study_record` VALUES (929, 115, '2026-11-18', 7104, '2026-11-18 14:50:36', '2026-11-18 23:59:52', 0, 0);
INSERT INTO `learning_study_record` VALUES (2683, 115, '2026-11-19', 32852, '2026-11-18 23:59:56', '2026-11-19 09:10:47', 0, 0);

-- ----------------------------
-- Table structure for learning_topic
-- ----------------------------
DROP TABLE IF EXISTS `learning_topic`;
CREATE TABLE `learning_topic`  (
  `topic_id` bigint NOT NULL AUTO_INCREMENT COMMENT '话题ID',
  `topic_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '话题名（不含 # 号，如 Android）',
  `topic_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '话题简介（话题页副标题）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`topic_id`) USING BTREE,
  INDEX `idx_topic_name`(`topic_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '话题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_topic
-- ----------------------------
INSERT INTO `learning_topic` VALUES (1, 'Android', 'Android 开发相关', '0', '0', 'admin', '2026-11-02 15:48:25', '', NULL);
INSERT INTO `learning_topic` VALUES (2, 'Kotlin', 'Kotlin 语言与协程', '0', '0', 'admin', '2026-11-02 15:48:25', '', NULL);
INSERT INTO `learning_topic` VALUES (3, 'Compose', 'Jetpack Compose', '0', '0', 'admin', '2026-11-02 15:48:25', '', NULL);
INSERT INTO `learning_topic` VALUES (4, 'Java', 'Java 基础与进阶', '0', '0', 'admin', '2026-11-02 15:48:25', '', NULL);
INSERT INTO `learning_topic` VALUES (5, 'MySQL', '数据库与 SQL 优化', '0', '0', 'admin', '2026-11-02 15:48:25', '', NULL);
INSERT INTO `learning_topic` VALUES (6, 'Redis', 'Redis 原理与实战', '0', '0', 'admin', '2026-11-02 15:48:25', '', NULL);
INSERT INTO `learning_topic` VALUES (7, '并发编程', '多线程与并发', '0', '0', 'admin', '2026-11-02 15:48:25', '', NULL);
INSERT INTO `learning_topic` VALUES (8, '后台测试话题2', '改过', '1', '2', 'admin', '2026-11-02 16:18:45', 'admin', '2026-11-02 16:18:47');
INSERT INTO `learning_topic` VALUES (9, '后台测试话题', '重建', '0', '2', 'admin', '2026-11-02 16:18:48', '', '2026-11-02 16:18:49');
INSERT INTO `learning_topic` VALUES (10, 'Jenkens', '自动化部署相关', '0', '2', 'admin', '2026-11-11 14:23:44', 'admin', '2026-11-11 14:24:02');

-- ----------------------------
-- Table structure for learning_user_profile
-- ----------------------------
DROP TABLE IF EXISTS `learning_user_profile`;
CREATE TABLE `learning_user_profile`  (
  `user_id` bigint NOT NULL COMMENT '用户ID（sys_user.user_id，一用户一行）',
  `bio` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '个人简介（纯文本，≤200字；null 表示没填）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户扩展资料（个人简介）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_user_profile
-- ----------------------------
INSERT INTO `learning_user_profile` VALUES (111, NULL, '2026-10-21 10:29:31', '2026-10-30 15:37:55');
INSERT INTO `learning_user_profile` VALUES (112, 'the first user', '2026-10-29 11:41:50', '2026-11-18 17:35:48');
INSERT INTO `learning_user_profile` VALUES (115, 'Ly', '2026-10-29 00:41:30', '2026-11-11 17:55:46');
INSERT INTO `learning_user_profile` VALUES (118, '超级无敌大帅哥', '2026-10-27 18:44:52', '2026-10-29 09:42:41');
INSERT INTO `learning_user_profile` VALUES (119, NULL, '2026-10-29 00:41:19', '2026-10-29 00:43:00');
INSERT INTO `learning_user_profile` VALUES (128, NULL, '2026-11-18 16:13:30', '2026-11-18 16:13:30');

-- ----------------------------
-- Table structure for learning_watch_history
-- ----------------------------
DROP TABLE IF EXISTS `learning_watch_history`;
CREATE TABLE `learning_watch_history`  (
  `history_id` bigint NOT NULL AUTO_INCREMENT COMMENT '历史ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（sys_user.user_id，从 Token 取）',
  `target_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容类型：shortVideo 短视频 / course 课程 / post 文章',
  `target_id` bigint NOT NULL COMMENT '内容ID：短视频ID / 课程ID / 帖子ID',
  `video_id` bigint NULL DEFAULT NULL COMMENT '课程：上次观看的小节ID（断点续播定位用）',
  `position` int NULL DEFAULT NULL COMMENT '视频：最近一次看到第几秒（重看直接覆盖）',
  `duration` int NULL DEFAULT NULL COMMENT '视频：总时长(秒)；短视频取内容表的，课程小节由客户端上报',
  `last_view_time` datetime NOT NULL COMMENT '最近观看时间（列表按它倒序）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '首次观看时间',
  PRIMARY KEY (`history_id`) USING BTREE,
  UNIQUE INDEX `uk_history_user_target`(`user_id` ASC, `target_type` ASC, `target_id` ASC) USING BTREE,
  INDEX `idx_history_user_time`(`user_id` ASC, `last_view_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22939 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '观看历史（短视频/课程/文章）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_watch_history
-- ----------------------------
INSERT INTO `learning_watch_history` VALUES (26, 115, 'shortVideo', 201, NULL, 20, 52, '2026-11-18 15:29:06', '2026-10-28 16:50:22');
INSERT INTO `learning_watch_history` VALUES (57, 115, 'course', 201, 201, 52, 615, '2026-11-11 17:28:47', '2026-10-28 17:11:27');
INSERT INTO `learning_watch_history` VALUES (404, 115, 'shortVideo', 203, NULL, 33, 52, '2026-11-11 22:10:06', '2026-10-29 16:05:24');
INSERT INTO `learning_watch_history` VALUES (712, 115, 'course', 202, 203, 9, 52, '2026-11-11 17:35:46', '2026-10-29 20:43:42');
INSERT INTO `learning_watch_history` VALUES (840, 111, 'course', 202, 203, 30, 52, '2026-11-17 10:56:11', '2026-10-30 17:52:59');
INSERT INTO `learning_watch_history` VALUES (855, 111, 'course', 205, NULL, NULL, NULL, '2026-11-10 17:18:10', '2026-11-04 14:04:18');
INSERT INTO `learning_watch_history` VALUES (856, 111, 'course', 201, NULL, NULL, NULL, '2026-11-10 17:19:08', '2026-11-04 14:06:07');
INSERT INTO `learning_watch_history` VALUES (887, 111, 'shortVideo', 201, NULL, NULL, 52, '2026-11-13 11:07:06', '2026-11-04 14:32:26');
INSERT INTO `learning_watch_history` VALUES (893, 111, 'shortVideo', 203, NULL, 2, 52, '2026-11-17 16:18:08', '2026-11-04 14:54:53');
INSERT INTO `learning_watch_history` VALUES (1246, 115, 'shortVideo', 202, NULL, 47, 52, '2026-11-11 17:36:09', '2026-11-05 16:15:16');
INSERT INTO `learning_watch_history` VALUES (1247, 115, 'course', 205, NULL, NULL, NULL, '2026-11-05 16:15:44', '2026-11-05 16:15:44');
INSERT INTO `learning_watch_history` VALUES (1268, 115, 'post', 223, NULL, NULL, NULL, '2026-11-11 16:06:37', '2026-11-05 17:20:55');
INSERT INTO `learning_watch_history` VALUES (1961, 112, 'course', 204, NULL, NULL, NULL, '2026-11-13 14:10:04', '2026-11-06 14:56:14');
INSERT INTO `learning_watch_history` VALUES (1962, 112, 'post', 101, NULL, NULL, NULL, '2026-11-06 15:20:31', '2026-11-06 14:56:27');
INSERT INTO `learning_watch_history` VALUES (1965, 112, 'course', 202, NULL, NULL, NULL, '2026-11-18 16:06:22', '2026-11-06 15:06:51');
INSERT INTO `learning_watch_history` VALUES (1967, 112, 'course', 203, NULL, NULL, NULL, '2026-11-18 16:01:22', '2026-11-06 15:12:31');
INSERT INTO `learning_watch_history` VALUES (1969, 112, 'course', 205, NULL, NULL, NULL, '2026-11-13 11:08:31', '2026-11-06 15:12:54');
INSERT INTO `learning_watch_history` VALUES (1970, 112, 'shortVideo', 203, NULL, NULL, 52, '2026-11-18 16:16:15', '2026-11-06 15:19:03');
INSERT INTO `learning_watch_history` VALUES (1972, 112, 'post', 201, NULL, NULL, NULL, '2026-11-06 15:19:36', '2026-11-06 15:19:36');
INSERT INTO `learning_watch_history` VALUES (1976, 112, 'post', 211, NULL, NULL, NULL, '2026-11-18 16:04:17', '2026-11-06 15:30:01');
INSERT INTO `learning_watch_history` VALUES (1982, 112, 'shortVideo', 202, NULL, NULL, 52, '2026-11-18 16:15:24', '2026-11-06 15:39:54');
INSERT INTO `learning_watch_history` VALUES (1983, 112, 'shortVideo', 201, NULL, NULL, 52, '2026-11-18 15:00:25', '2026-11-06 15:40:10');
INSERT INTO `learning_watch_history` VALUES (1984, 112, 'post', 223, NULL, NULL, NULL, '2026-11-18 17:50:07', '2026-11-06 15:40:59');
INSERT INTO `learning_watch_history` VALUES (1985, 112, 'post', 214, NULL, NULL, NULL, '2026-11-18 17:41:53', '2026-11-06 15:41:20');
INSERT INTO `learning_watch_history` VALUES (1989, 115, 'post', 205, NULL, NULL, NULL, '2026-11-11 16:06:46', '2026-11-06 15:58:52');
INSERT INTO `learning_watch_history` VALUES (1995, 112, 'post', 204, NULL, NULL, NULL, '2026-11-18 14:40:11', '2026-11-06 16:11:40');
INSERT INTO `learning_watch_history` VALUES (1998, 112, 'post', 203, NULL, NULL, NULL, '2026-11-13 11:05:48', '2026-11-06 16:17:41');
INSERT INTO `learning_watch_history` VALUES (2001, 112, 'post', 205, NULL, NULL, NULL, '2026-11-18 17:46:53', '2026-11-06 16:20:12');
INSERT INTO `learning_watch_history` VALUES (2050, 115, 'post', 211, NULL, NULL, NULL, '2026-11-06 22:32:41', '2026-11-06 22:32:41');
INSERT INTO `learning_watch_history` VALUES (2059, 112, 'course', 201, NULL, NULL, NULL, '2026-11-18 16:07:45', '2026-11-09 09:08:33');
INSERT INTO `learning_watch_history` VALUES (2077, 115, 'course', 204, NULL, NULL, NULL, '2026-11-09 11:06:24', '2026-11-09 11:06:24');
INSERT INTO `learning_watch_history` VALUES (2080, 111, 'shortVideo', 202, NULL, NULL, 52, '2026-11-13 11:07:05', '2026-11-10 15:55:33');
INSERT INTO `learning_watch_history` VALUES (2081, 111, 'post', 223, NULL, NULL, NULL, '2026-11-17 09:08:51', '2026-11-10 16:01:57');
INSERT INTO `learning_watch_history` VALUES (2096, 115, 'course', 203, NULL, NULL, NULL, '2026-11-11 14:48:17', '2026-11-11 14:48:17');
INSERT INTO `learning_watch_history` VALUES (2099, 115, 'post', 214, NULL, NULL, NULL, '2026-11-11 16:06:31', '2026-11-11 16:06:31');
INSERT INTO `learning_watch_history` VALUES (2479, 112, 'shortVideo', 210, NULL, NULL, 5, '2026-11-18 16:23:44', '2026-11-13 14:09:35');
INSERT INTO `learning_watch_history` VALUES (2480, 112, 'shortVideo', 209, NULL, NULL, 4, '2026-11-18 16:23:44', '2026-11-13 14:09:36');
INSERT INTO `learning_watch_history` VALUES (2481, 112, 'shortVideo', 208, NULL, NULL, 6, '2026-11-18 16:23:45', '2026-11-13 14:09:37');
INSERT INTO `learning_watch_history` VALUES (2482, 112, 'shortVideo', 207, NULL, NULL, 5, '2026-11-18 16:16:12', '2026-11-13 14:09:38');
INSERT INTO `learning_watch_history` VALUES (2483, 112, 'shortVideo', 206, NULL, NULL, 4, '2026-11-18 16:16:13', '2026-11-13 14:09:38');
INSERT INTO `learning_watch_history` VALUES (2484, 112, 'shortVideo', 205, NULL, NULL, 6, '2026-11-18 16:16:13', '2026-11-13 14:09:39');
INSERT INTO `learning_watch_history` VALUES (2485, 112, 'shortVideo', 204, NULL, NULL, 5, '2026-11-18 16:16:28', '2026-11-13 14:09:39');
INSERT INTO `learning_watch_history` VALUES (2509, 112, 'shortVideo', 211, NULL, NULL, 6, '2026-11-18 16:23:43', '2026-11-13 14:10:22');
INSERT INTO `learning_watch_history` VALUES (2510, 112, 'shortVideo', 218, NULL, NULL, 4, '2026-11-18 17:36:08', '2026-11-13 14:14:55');
INSERT INTO `learning_watch_history` VALUES (2511, 112, 'shortVideo', 217, NULL, NULL, 6, '2026-11-18 16:23:54', '2026-11-13 14:15:03');
INSERT INTO `learning_watch_history` VALUES (2512, 112, 'shortVideo', 216, NULL, NULL, 5, '2026-11-18 16:23:55', '2026-11-13 14:15:04');
INSERT INTO `learning_watch_history` VALUES (2517, 112, 'shortVideo', 215, NULL, NULL, 4, '2026-11-18 16:23:56', '2026-11-13 14:15:10');
INSERT INTO `learning_watch_history` VALUES (2518, 112, 'shortVideo', 214, NULL, NULL, 6, '2026-11-18 16:23:57', '2026-11-13 14:23:28');
INSERT INTO `learning_watch_history` VALUES (2521, 111, 'shortVideo', 218, NULL, NULL, 4, '2026-11-18 16:22:24', '2026-11-17 09:12:25');
INSERT INTO `learning_watch_history` VALUES (2526, 111, 'shortVideo', 215, NULL, 0, 4, '2026-11-17 09:12:43', '2026-11-17 09:12:43');
INSERT INTO `learning_watch_history` VALUES (2527, 111, 'shortVideo', 212, NULL, 0, 4, '2026-11-17 09:12:47', '2026-11-17 09:12:46');
INSERT INTO `learning_watch_history` VALUES (2529, 111, 'shortVideo', 210, NULL, 3, 5, '2026-11-17 09:12:53', '2026-11-17 09:12:50');
INSERT INTO `learning_watch_history` VALUES (2531, 111, 'shortVideo', 209, NULL, 0, 4, '2026-11-17 09:12:54', '2026-11-17 09:12:53');
INSERT INTO `learning_watch_history` VALUES (2533, 111, 'shortVideo', 208, NULL, 0, 6, '2026-11-17 14:16:19', '2026-11-17 09:12:55');
INSERT INTO `learning_watch_history` VALUES (2535, 111, 'shortVideo', 207, NULL, 1, 5, '2026-11-17 14:16:26', '2026-11-17 09:13:00');
INSERT INTO `learning_watch_history` VALUES (2537, 111, 'shortVideo', 206, NULL, 0, 4, '2026-11-17 14:16:23', '2026-11-17 09:13:03');
INSERT INTO `learning_watch_history` VALUES (2539, 111, 'shortVideo', 205, NULL, 2, 6, '2026-11-17 09:13:11', '2026-11-17 09:13:07');
INSERT INTO `learning_watch_history` VALUES (2563, 111, 'shortVideo', 217, NULL, NULL, 6, '2026-11-18 16:22:41', '2026-11-17 11:02:35');
INSERT INTO `learning_watch_history` VALUES (2565, 111, 'shortVideo', 216, NULL, NULL, 5, '2026-11-18 16:22:43', '2026-11-17 11:02:36');
INSERT INTO `learning_watch_history` VALUES (2567, 111, 'shortVideo', 214, NULL, 4, 6, '2026-11-17 11:03:39', '2026-11-17 11:02:40');
INSERT INTO `learning_watch_history` VALUES (2606, 123, 'shortVideo', 218, NULL, NULL, 4, '2026-11-17 14:44:20', '2026-11-17 14:44:20');
INSERT INTO `learning_watch_history` VALUES (2610, 126, 'shortVideo', 218, NULL, NULL, 4, '2026-11-18 13:56:49', '2026-11-17 15:09:53');
INSERT INTO `learning_watch_history` VALUES (2611, 125, 'shortVideo', 218, NULL, NULL, 4, '2026-11-17 15:22:38', '2026-11-17 15:14:33');
INSERT INTO `learning_watch_history` VALUES (2614, 126, 'shortVideo', 217, NULL, NULL, 6, '2026-11-18 13:56:52', '2026-11-17 15:55:18');
INSERT INTO `learning_watch_history` VALUES (2615, 126, 'shortVideo', 216, NULL, NULL, 5, '2026-11-18 13:56:53', '2026-11-17 15:55:20');
INSERT INTO `learning_watch_history` VALUES (2616, 126, 'shortVideo', 215, NULL, NULL, 4, '2026-11-18 13:56:53', '2026-11-17 15:55:21');
INSERT INTO `learning_watch_history` VALUES (2617, 126, 'shortVideo', 214, NULL, NULL, 6, '2026-11-18 13:56:54', '2026-11-17 15:55:22');
INSERT INTO `learning_watch_history` VALUES (2636, 126, 'shortVideo', 213, NULL, NULL, 5, '2026-11-18 11:11:14', '2026-11-17 16:06:01');
INSERT INTO `learning_watch_history` VALUES (2643, 126, 'shortVideo', 212, NULL, NULL, 4, '2026-11-18 11:11:14', '2026-11-17 16:09:14');
INSERT INTO `learning_watch_history` VALUES (2644, 126, 'shortVideo', 211, NULL, NULL, 6, '2026-11-18 11:11:15', '2026-11-17 16:09:16');
INSERT INTO `learning_watch_history` VALUES (2645, 126, 'shortVideo', 210, NULL, NULL, 5, '2026-11-18 11:11:16', '2026-11-17 16:09:19');
INSERT INTO `learning_watch_history` VALUES (2646, 126, 'shortVideo', 209, NULL, NULL, 4, '2026-11-18 11:11:16', '2026-11-17 16:09:21');
INSERT INTO `learning_watch_history` VALUES (2647, 126, 'shortVideo', 208, NULL, NULL, 6, '2026-11-18 11:11:19', '2026-11-17 16:09:37');
INSERT INTO `learning_watch_history` VALUES (2648, 126, 'shortVideo', 207, NULL, NULL, 5, '2026-11-18 11:14:49', '2026-11-17 16:09:39');
INSERT INTO `learning_watch_history` VALUES (2649, 126, 'shortVideo', 206, NULL, NULL, 4, '2026-11-18 11:14:49', '2026-11-17 16:09:40');
INSERT INTO `learning_watch_history` VALUES (2650, 126, 'shortVideo', 205, NULL, NULL, 6, '2026-11-18 11:14:50', '2026-11-17 16:09:42');
INSERT INTO `learning_watch_history` VALUES (2651, 126, 'shortVideo', 204, NULL, NULL, 5, '2026-11-18 11:14:57', '2026-11-17 16:09:44');
INSERT INTO `learning_watch_history` VALUES (2652, 126, 'shortVideo', 203, NULL, NULL, 52, '2026-11-18 11:14:58', '2026-11-17 16:09:48');
INSERT INTO `learning_watch_history` VALUES (2653, 126, 'shortVideo', 202, NULL, NULL, 52, '2026-11-18 11:14:56', '2026-11-17 16:09:50');
INSERT INTO `learning_watch_history` VALUES (2660, 111, 'post', 214, NULL, NULL, NULL, '2026-11-17 16:12:57', '2026-11-17 16:12:57');
INSERT INTO `learning_watch_history` VALUES (2678, 126, 'shortVideo', 201, NULL, NULL, 52, '2026-11-18 11:14:52', '2026-11-17 16:16:23');
INSERT INTO `learning_watch_history` VALUES (2722, 126, 'course', 204, NULL, NULL, NULL, '2026-11-18 11:43:55', '2026-11-18 11:10:32');
INSERT INTO `learning_watch_history` VALUES (2750, 112, 'shortVideo', 213, NULL, NULL, 5, '2026-11-18 16:23:59', '2026-11-18 11:18:09');
INSERT INTO `learning_watch_history` VALUES (2751, 112, 'shortVideo', 212, NULL, NULL, 4, '2026-11-18 16:23:43', '2026-11-18 11:18:10');
INSERT INTO `learning_watch_history` VALUES (2763, 126, 'course', 202, NULL, NULL, NULL, '2026-11-18 11:43:16', '2026-11-18 11:43:16');
INSERT INTO `learning_watch_history` VALUES (2766, 126, 'post', 223, NULL, NULL, NULL, '2026-11-18 11:47:13', '2026-11-18 11:47:13');
INSERT INTO `learning_watch_history` VALUES (2847, 115, 'shortVideo', 216, NULL, 2, 5, '2026-11-18 15:16:58', '2026-11-18 14:50:31');
INSERT INTO `learning_watch_history` VALUES (2870, 115, 'shortVideo', 218, NULL, 1, 4, '2026-11-19 09:10:05', '2026-11-18 14:51:36');
INSERT INTO `learning_watch_history` VALUES (2980, 115, 'shortVideo', 215, NULL, 0, 4, '2026-11-19 09:05:31', '2026-11-18 15:16:59');
INSERT INTO `learning_watch_history` VALUES (2982, 115, 'shortVideo', 212, NULL, 1, 4, '2026-11-19 09:10:20', '2026-11-18 15:17:05');
INSERT INTO `learning_watch_history` VALUES (2988, 115, 'shortVideo', 209, NULL, 1, 4, '2026-11-19 09:10:28', '2026-11-18 15:20:11');
INSERT INTO `learning_watch_history` VALUES (3043, 115, 'shortVideo', 208, NULL, 2, 6, '2026-11-19 09:10:47', '2026-11-18 15:22:15');
INSERT INTO `learning_watch_history` VALUES (3067, 115, 'shortVideo', 214, NULL, 0, 6, '2026-11-18 15:26:07', '2026-11-18 15:23:29');
INSERT INTO `learning_watch_history` VALUES (3250, 115, 'shortVideo', 217, NULL, 0, 6, '2026-11-18 15:33:04', '2026-11-18 15:32:56');
INSERT INTO `learning_watch_history` VALUES (3263, 126, 'course', 205, NULL, NULL, NULL, '2026-11-18 15:36:09', '2026-11-18 15:36:09');
INSERT INTO `learning_watch_history` VALUES (4113, 128, 'shortVideo', 218, NULL, NULL, 4, '2026-11-18 16:09:58', '2026-11-18 16:09:58');
INSERT INTO `learning_watch_history` VALUES (4116, 128, 'shortVideo', 217, NULL, NULL, 6, '2026-11-18 16:10:01', '2026-11-18 16:10:01');
INSERT INTO `learning_watch_history` VALUES (4117, 128, 'shortVideo', 216, NULL, NULL, 5, '2026-11-18 16:10:01', '2026-11-18 16:10:01');
INSERT INTO `learning_watch_history` VALUES (4118, 128, 'shortVideo', 215, NULL, NULL, 4, '2026-11-18 16:10:02', '2026-11-18 16:10:02');
INSERT INTO `learning_watch_history` VALUES (4121, 128, 'shortVideo', 214, NULL, NULL, 6, '2026-11-18 16:10:04', '2026-11-18 16:10:04');
INSERT INTO `learning_watch_history` VALUES (4122, 128, 'shortVideo', 213, NULL, NULL, 5, '2026-11-18 16:10:04', '2026-11-18 16:10:04');
INSERT INTO `learning_watch_history` VALUES (22668, 115, 'shortVideo', 213, NULL, 1, 5, '2026-11-19 08:59:57', '2026-11-19 08:59:55');
INSERT INTO `learning_watch_history` VALUES (22670, 115, 'shortVideo', 207, NULL, 5, 5, '2026-11-19 09:04:06', '2026-11-19 09:00:04');
INSERT INTO `learning_watch_history` VALUES (22929, 115, 'shortVideo', 211, NULL, 0, 6, '2026-11-19 09:10:24', '2026-11-19 09:10:23');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '深黑主题theme-dark，浅色主题theme-light，深蓝主题theme-blue');
INSERT INTO `sys_config` VALUES (4, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2026-10-13 09:00:52', 'system', '2026-10-13 09:39:28', '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '用户管理-密码字符范围', 'sys.account.chrtype', '0', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');
INSERT INTO `sys_config` VALUES (6, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (7, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '主框架页-菜单导航显示风格', 'sys.index.menuStyle', 'default', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '菜单导航显示风格（default为左侧导航菜单，topnav为顶部导航菜单）');
INSERT INTO `sys_config` VALUES (9, '主框架页-是否开启页脚', 'sys.index.footer', 'true', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '是否开启底部页脚显示（true显示，false隐藏）');
INSERT INTO `sys_config` VALUES (10, '主框架页-是否开启页签', 'sys.index.tagsView', 'true', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '是否开启菜单多页签显示（true显示，false隐藏）');
INSERT INTO `sys_config` VALUES (11, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-10-13 09:00:52', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (100, '注册用户默认角色', 'sys.account.defaultRole', 'common', 'Y', 'system', '2026-10-13 09:39:28', '', NULL, '注册接口分配的默认角色 role_key');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 114 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '不公开', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-10-13 09:00:52', '', '2026-10-21 11:03:38', '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 1, '课程', 'course', 'sys_category_type', '', 'primary', 'Y', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '课程模块类别');
INSERT INTO `sys_dict_data` VALUES (101, 2, '社区文章', 'article', 'sys_category_type', '', 'warning', 'N', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '社区文章模块类别');
INSERT INTO `sys_dict_data` VALUES (102, 1, '已发布', '0', 'sys_post_status', '', 'success', 'N', '0', 'admin', '2026-10-13 17:25:48', '', NULL, '帖子已发布，所有人可见');
INSERT INTO `sys_dict_data` VALUES (103, 2, '草稿', '1', 'sys_post_status', '', 'info', 'Y', '0', 'admin', '2026-10-13 17:25:48', '', NULL, '帖子草稿，仅作者与管理员可见');
INSERT INTO `sys_dict_data` VALUES (104, 3, '已下架', '2', 'sys_post_status', '', 'danger', 'N', '0', 'admin', '2026-10-13 17:25:48', '', NULL, '帖子已下架，仅管理员可恢复');
INSERT INTO `sys_dict_data` VALUES (105, 1, '正常', '0', 'sys_video_status', '', 'primary', 'Y', '0', 'admin', '2026-10-14 11:35:58', '', NULL, '正常，小程序可见');
INSERT INTO `sys_dict_data` VALUES (106, 2, '停用', '1', 'sys_video_status', '', 'danger', 'N', '0', 'admin', '2026-10-14 11:35:58', '', NULL, '停用，小程序不可见');
INSERT INTO `sys_dict_data` VALUES (107, 1, '社区帖子', '1', 'sys_interaction_target', '', 'primary', 'Y', '0', 'admin', '2026-10-14 15:06:49', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (108, 2, '课程', '2', 'sys_interaction_target', '', 'success', 'N', '0', 'admin', '2026-10-14 15:06:49', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (109, 3, '短视频', '3', 'sys_interaction_target', '', 'warning', 'N', '0', 'admin', '2026-10-14 15:06:49', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (110, 1, '点赞', '1', 'sys_interaction_type', '', 'danger', 'Y', '0', 'admin', '2026-10-14 15:06:50', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (111, 2, '收藏', '2', 'sys_interaction_type', '', 'info', 'N', '0', 'admin', '2026-10-14 15:06:50', '', NULL, '');
INSERT INTO `sys_dict_data` VALUES (112, 4, '待审核', '3', 'sys_post_status', '', 'warning', 'N', '0', 'admin', '2026-10-15 15:02:32', '', NULL, '帖子已提交，等待管理员审核，仅作者与审核人可见');
INSERT INTO `sys_dict_data` VALUES (113, 5, '已驳回', '4', 'sys_post_status', '', 'danger', 'N', '0', 'admin', '2026-10-15 15:02:32', '', NULL, '帖子审核未通过，作者可修改后重新提交审核');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 105 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '类别类型', 'sys_category_type', '0', 'admin', '2026-10-13 10:43:27', '', NULL, '学习平台类别类型列表');
INSERT INTO `sys_dict_type` VALUES (101, '帖子状态', 'sys_post_status', '0', 'admin', '2026-10-13 17:25:48', '', NULL, '社区帖子状态列表');
INSERT INTO `sys_dict_type` VALUES (102, '视频状态', 'sys_video_status', '0', 'admin', '2026-10-14 11:35:58', '', NULL, '短视频状态列表');
INSERT INTO `sys_dict_type` VALUES (103, '互动目标类型', 'sys_interaction_target', '0', 'admin', '2026-10-14 15:06:49', '', NULL, '点赞收藏的目标类型');
INSERT INTO `sys_dict_type` VALUES (104, '互动类型', 'sys_interaction_type', '0', 'admin', '2026-10-14 15:06:49', '', NULL, '点赞 / 收藏');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-10-13 09:00:52', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-10-13 09:00:52', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-10-13 09:00:52', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '异常信息',
  `start_time` datetime NULL DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `login_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 892 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, '15888888888', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '登录成功', '2026-10-13 09:41:12');
INSERT INTO `sys_logininfor` VALUES (101, '15888888888', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '登录成功', '2026-10-13 09:41:18');
INSERT INTO `sys_logininfor` VALUES (102, '13900001111', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '注册成功', '2026-10-13 09:41:24');
INSERT INTO `sys_logininfor` VALUES (103, '13900001111', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '登录成功', '2026-10-13 09:41:31');
INSERT INTO `sys_logininfor` VALUES (104, '13900002222', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '注册成功', '2026-10-13 09:43:43');
INSERT INTO `sys_logininfor` VALUES (105, '13900002222', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '登录成功', '2026-10-13 09:43:44');
INSERT INTO `sys_logininfor` VALUES (106, '13900002222', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '1', '密码输入错误1次', '2026-10-13 09:43:45');
INSERT INTO `sys_logininfor` VALUES (107, '13900001111', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '登录成功', '2026-10-13 09:43:45');
INSERT INTO `sys_logininfor` VALUES (108, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '注册成功', '2026-10-13 10:44:58');
INSERT INTO `sys_logininfor` VALUES (109, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '登录成功', '2026-10-13 10:44:58');
INSERT INTO `sys_logininfor` VALUES (110, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '登录成功', '2026-10-13 10:46:30');
INSERT INTO `sys_logininfor` VALUES (111, '13900000001', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 10:46:51');
INSERT INTO `sys_logininfor` VALUES (112, '13900000001', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 10:48:19');
INSERT INTO `sys_logininfor` VALUES (113, '13900000001', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 10:48:24');
INSERT INTO `sys_logininfor` VALUES (114, '13900000001', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 10:48:30');
INSERT INTO `sys_logininfor` VALUES (115, '15888888888', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 11:00:45');
INSERT INTO `sys_logininfor` VALUES (116, '13900000002', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '注册成功', '2026-10-13 11:00:49');
INSERT INTO `sys_logininfor` VALUES (117, '13900000002', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 11:00:49');
INSERT INTO `sys_logininfor` VALUES (118, '15888888888', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 11:01:15');
INSERT INTO `sys_logininfor` VALUES (119, '13900000002', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 11:02:15');
INSERT INTO `sys_logininfor` VALUES (120, '13800000000', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 11:27:20');
INSERT INTO `sys_logininfor` VALUES (121, '13900000003', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '注册成功', '2026-10-13 11:27:24');
INSERT INTO `sys_logininfor` VALUES (122, '13900000003', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 11:27:24');
INSERT INTO `sys_logininfor` VALUES (123, '15888888888', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-10-13 11:27:25');
INSERT INTO `sys_logininfor` VALUES (124, '15888888888', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '登录成功', '2026-10-13 14:27:00');
INSERT INTO `sys_logininfor` VALUES (125, '15888888888', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '0', '登录成功', '2026-10-13 14:37:30');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 155', 'Windows10', '1', '验证码错误', '2026-10-13 14:38:29');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 155', 'Windows10', '0', '登录成功', '2026-10-13 14:38:40');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-13 14:39:21');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '验证码错误', '2026-10-13 14:57:43');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '验证码错误', '2026-10-13 14:57:53');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '验证码错误', '2026-10-13 14:58:34');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-13 15:00:50');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '退出成功', '2026-10-13 15:01:11');
INSERT INTO `sys_logininfor` VALUES (134, '13900001111', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '0', '注册成功', '2026-10-13 15:04:07');
INSERT INTO `sys_logininfor` VALUES (135, '13900001111', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '0', '登录成功', '2026-10-13 15:04:54');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 155', 'Windows10', '0', '登录成功', '2026-10-13 15:39:15');
INSERT INTO `sys_logininfor` VALUES (137, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-13 15:48:09');
INSERT INTO `sys_logininfor` VALUES (138, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '退出成功', '2026-10-13 15:48:14');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 155', 'Windows10', '0', '退出成功', '2026-10-13 15:49:42');
INSERT INTO `sys_logininfor` VALUES (140, '18085885945', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '0', '注册成功', '2026-10-13 15:51:32');
INSERT INTO `sys_logininfor` VALUES (141, '13900001111', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '密码输入错误1次', '2026-10-13 16:20:19');
INSERT INTO `sys_logininfor` VALUES (142, '13900001111', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '密码输入错误2次', '2026-10-13 16:20:20');
INSERT INTO `sys_logininfor` VALUES (143, '13900001111', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '密码输入错误3次', '2026-10-13 16:20:21');
INSERT INTO `sys_logininfor` VALUES (144, '13900001111', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '密码输入错误4次', '2026-10-13 16:20:21');
INSERT INTO `sys_logininfor` VALUES (145, '13900001111', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '密码输入错误5次', '2026-10-13 16:20:22');
INSERT INTO `sys_logininfor` VALUES (146, '13900001111', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '密码输入错误5次，帐户锁定10分钟', '2026-10-13 16:20:23');
INSERT INTO `sys_logininfor` VALUES (147, '13900001111', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '密码输入错误5次，帐户锁定10分钟', '2026-10-13 16:20:23');
INSERT INTO `sys_logininfor` VALUES (148, '19000000001', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '0', '注册成功', '2026-10-13 16:30:27');
INSERT INTO `sys_logininfor` VALUES (149, 'zz_no_such_user', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '1', '用户不存在/密码错误', '2026-10-13 16:32:57');
INSERT INTO `sys_logininfor` VALUES (150, 'zz_no_such_user', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '1', '用户不存在/密码错误', '2026-10-13 16:32:57');
INSERT INTO `sys_logininfor` VALUES (151, 'zz_no_such_user', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '1', '用户不存在/密码错误', '2026-10-13 16:32:57');
INSERT INTO `sys_logininfor` VALUES (152, 'zz_no_such_user', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '1', '用户不存在/密码错误', '2026-10-13 16:33:02');
INSERT INTO `sys_logininfor` VALUES (153, 'zz_no_such_user', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '1', '用户不存在/密码错误', '2026-10-13 16:33:02');
INSERT INTO `sys_logininfor` VALUES (154, '13900000000', '127.0.0.1', '内网IP', 'Curl 8.12.1', '', '1', '用户不存在/密码错误', '2026-10-13 16:33:02');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '验证码错误', '2026-10-13 17:01:43');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '验证码错误', '2026-10-13 17:01:56');
INSERT INTO `sys_logininfor` VALUES (157, '13900007777', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '0', '注册成功', '2026-10-13 17:04:42');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '验证码错误', '2026-10-13 17:11:14');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '验证码错误', '2026-10-13 17:14:02');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '58.16.41.98', 'XX XX', 'Apifox 1.0.0', '', '1', '验证码错误', '2026-10-13 17:16:55');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Android 6.0', '1', '验证码错误', '2026-10-13 17:19:16');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Android 6.0', '1', '验证码错误', '2026-10-13 17:21:06');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '172.18.0.1', '内网IP', 'Curl 7.81.0', '', '1', '验证码错误', '2026-10-13 17:28:14');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Android 6.0', '1', '验证码错误', '2026-10-13 17:33:19');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '172.18.0.1', '内网IP', 'Curl 7.81.0', '', '1', '验证码错误', '2026-10-13 17:40:48');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '172.18.0.1', '内网IP', 'Curl 7.81.0', '', '1', '验证码错误', '2026-10-13 17:41:29');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Chrome 155', 'Windows10', '0', '登录成功', '2026-10-13 17:45:21');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-13 17:50:57');
INSERT INTO `sys_logininfor` VALUES (169, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 09:15:52');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 09:28:57');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '退出成功', '2026-10-14 09:32:14');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '1', '密码输入错误1次', '2026-10-14 09:50:13');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 09:50:27');
INSERT INTO `sys_logininfor` VALUES (174, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 09:54:32');
INSERT INTO `sys_logininfor` VALUES (175, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 09:56:12');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '退出成功', '2026-10-14 09:57:02');
INSERT INTO `sys_logininfor` VALUES (177, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 09:57:11');
INSERT INTO `sys_logininfor` VALUES (178, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 09:58:20');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '172.18.0.1', '内网IP', 'Curl 7.81.0', '', '1', '验证码错误', '2026-10-14 10:15:47');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '172.18.0.1', '内网IP', 'Curl 7.81.0', '', '1', '验证码错误', '2026-10-14 10:27:17');
INSERT INTO `sys_logininfor` VALUES (181, '13900001111', '172.18.0.1', '内网IP', 'Curl 7.81.0', '', '0', '登录成功', '2026-10-14 10:30:08');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Curl 8.18.0', '', '1', '验证码错误', '2026-10-14 10:33:12');
INSERT INTO `sys_logininfor` VALUES (183, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 10:50:08');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 10:54:02');
INSERT INTO `sys_logininfor` VALUES (185, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '退出成功', '2026-10-14 10:57:08');
INSERT INTO `sys_logininfor` VALUES (186, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '1', '验证码错误', '2026-10-14 10:57:27');
INSERT INTO `sys_logininfor` VALUES (187, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 10:57:32');
INSERT INTO `sys_logininfor` VALUES (188, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 11:26:56');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '58.16.41.98', 'XX XX', 'Edge 155', 'Windows >=10', '0', '登录成功', '2026-10-14 11:32:55');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 11:34:00');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 13:57:00');
INSERT INTO `sys_logininfor` VALUES (192, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '退出成功', '2026-10-14 13:58:17');
INSERT INTO `sys_logininfor` VALUES (193, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-14 13:58:31');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '1', '验证码错误', '2026-10-14 14:14:31');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '1', '密码输入错误1次', '2026-10-14 14:14:33');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '1', '密码输入错误2次', '2026-10-14 14:14:38');
INSERT INTO `sys_logininfor` VALUES (197, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '1', '密码输入错误1次', '2026-10-14 14:15:04');
INSERT INTO `sys_logininfor` VALUES (198, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '1', '密码输入错误2次', '2026-10-14 14:15:09');
INSERT INTO `sys_logininfor` VALUES (199, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '1', '密码输入错误3次', '2026-10-14 14:15:14');
INSERT INTO `sys_logininfor` VALUES (200, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '0', '登录成功', '2026-10-14 14:15:25');
INSERT INTO `sys_logininfor` VALUES (201, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '0', '退出成功', '2026-10-14 14:31:16');
INSERT INTO `sys_logininfor` VALUES (202, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '0', '登录成功', '2026-10-14 14:33:39');
INSERT INTO `sys_logininfor` VALUES (203, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '0', '登录成功', '2026-10-14 15:18:13');
INSERT INTO `sys_logininfor` VALUES (204, '13900000099', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '1', '用户不存在/密码错误', '2026-10-14 15:45:43');
INSERT INTO `sys_logininfor` VALUES (205, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '注册成功', '2026-10-14 15:45:54');
INSERT INTO `sys_logininfor` VALUES (206, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 15:45:54');
INSERT INTO `sys_logininfor` VALUES (207, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '1', '密码输入错误1次', '2026-10-14 15:45:55');
INSERT INTO `sys_logininfor` VALUES (208, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 15:46:11');
INSERT INTO `sys_logininfor` VALUES (209, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 15:46:32');
INSERT INTO `sys_logininfor` VALUES (210, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 15:46:33');
INSERT INTO `sys_logininfor` VALUES (211, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 15:47:18');
INSERT INTO `sys_logininfor` VALUES (212, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 16:03:09');
INSERT INTO `sys_logininfor` VALUES (213, 'eduadmin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '1', '验证码错误', '2026-10-14 16:03:42');
INSERT INTO `sys_logininfor` VALUES (214, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 16:10:18');
INSERT INTO `sys_logininfor` VALUES (215, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 16:19:57');
INSERT INTO `sys_logininfor` VALUES (216, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 16:22:07');
INSERT INTO `sys_logininfor` VALUES (217, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-14 16:23:16');
INSERT INTO `sys_logininfor` VALUES (218, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '1', '验证码错误', '2026-10-14 16:27:17');
INSERT INTO `sys_logininfor` VALUES (219, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 155', 'Windows >=10', '0', '登录成功', '2026-10-14 16:27:21');
INSERT INTO `sys_logininfor` VALUES (220, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '注册成功', '2026-10-14 17:06:57');
INSERT INTO `sys_logininfor` VALUES (221, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '登录成功', '2026-10-14 17:07:11');
INSERT INTO `sys_logininfor` VALUES (222, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '登录成功', '2026-10-14 17:09:06');
INSERT INTO `sys_logininfor` VALUES (223, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-14 18:01:47');
INSERT INTO `sys_logininfor` VALUES (224, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-15 09:27:49');
INSERT INTO `sys_logininfor` VALUES (225, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-15 10:14:29');
INSERT INTO `sys_logininfor` VALUES (226, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-15 10:15:30');
INSERT INTO `sys_logininfor` VALUES (227, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 10:54:50');
INSERT INTO `sys_logininfor` VALUES (228, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 10:55:02');
INSERT INTO `sys_logininfor` VALUES (229, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 11:03:10');
INSERT INTO `sys_logininfor` VALUES (230, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-15 14:04:36');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 16:01:32');
INSERT INTO `sys_logininfor` VALUES (232, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 16:01:42');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '退出成功', '2026-10-15 16:03:31');
INSERT INTO `sys_logininfor` VALUES (234, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '1', '验证码错误', '2026-10-15 16:06:08');
INSERT INTO `sys_logininfor` VALUES (235, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 16:06:11');
INSERT INTO `sys_logininfor` VALUES (236, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 16:06:21');
INSERT INTO `sys_logininfor` VALUES (237, '13900139001', '220.197.4.211', 'XX XX', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '登录成功', '2026-10-15 17:10:37');
INSERT INTO `sys_logininfor` VALUES (238, '13900139001', '220.197.4.211', 'XX XX', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '登录成功', '2026-10-15 17:11:03');
INSERT INTO `sys_logininfor` VALUES (239, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 17:25:50');
INSERT INTO `sys_logininfor` VALUES (240, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '1', '验证码错误', '2026-10-15 17:28:44');
INSERT INTO `sys_logininfor` VALUES (241, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '1', '验证码错误', '2026-10-15 17:28:51');
INSERT INTO `sys_logininfor` VALUES (242, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 17:28:53');
INSERT INTO `sys_logininfor` VALUES (243, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-15 17:29:05');
INSERT INTO `sys_logininfor` VALUES (244, '13900139001', '220.197.4.211', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-15 17:37:10');
INSERT INTO `sys_logininfor` VALUES (245, '13900139001', '220.197.4.211', 'XX XX', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '登录成功', '2026-10-15 17:38:34');
INSERT INTO `sys_logininfor` VALUES (246, '13900139001', '220.197.4.211', 'XX XX', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '登录成功', '2026-10-15 17:39:24');
INSERT INTO `sys_logininfor` VALUES (247, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-16 14:15:53');
INSERT INTO `sys_logininfor` VALUES (248, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-16 14:41:06');
INSERT INTO `sys_logininfor` VALUES (249, '13900139002', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '注册成功', '2026-10-16 14:42:09');
INSERT INTO `sys_logininfor` VALUES (250, '13900139002', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-16 14:42:26');
INSERT INTO `sys_logininfor` VALUES (251, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-16 14:42:27');
INSERT INTO `sys_logininfor` VALUES (252, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-16 14:48:57');
INSERT INTO `sys_logininfor` VALUES (253, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-16 15:04:55');
INSERT INTO `sys_logininfor` VALUES (254, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-16 15:30:57');
INSERT INTO `sys_logininfor` VALUES (255, '19885323438', '127.0.0.1', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '注册成功', '2026-10-16 15:51:54');
INSERT INTO `sys_logininfor` VALUES (256, '19885323438', '127.0.0.1', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-16 15:52:09');
INSERT INTO `sys_logininfor` VALUES (257, 'admin', '127.0.0.1', '内网IP', 'Safari 26.0', 'Mac OS >=10.15.7', '1', '验证码错误', '2026-10-16 16:04:41');
INSERT INTO `sys_logininfor` VALUES (258, 'admin', '127.0.0.1', '内网IP', 'Safari 26.0', 'Mac OS >=10.15.7', '0', '登录成功', '2026-10-16 16:04:46');
INSERT INTO `sys_logininfor` VALUES (259, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-16 16:50:32');
INSERT INTO `sys_logininfor` VALUES (260, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-16 16:52:37');
INSERT INTO `sys_logininfor` VALUES (261, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 10:22:07');
INSERT INTO `sys_logininfor` VALUES (262, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 10:22:43');
INSERT INTO `sys_logininfor` VALUES (263, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 10:22:59');
INSERT INTO `sys_logininfor` VALUES (264, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 10:23:15');
INSERT INTO `sys_logininfor` VALUES (265, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 10:23:33');
INSERT INTO `sys_logininfor` VALUES (266, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 10:23:47');
INSERT INTO `sys_logininfor` VALUES (267, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 10:50:45');
INSERT INTO `sys_logininfor` VALUES (268, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 11:31:32');
INSERT INTO `sys_logininfor` VALUES (269, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 11:31:51');
INSERT INTO `sys_logininfor` VALUES (270, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 11:32:16');
INSERT INTO `sys_logininfor` VALUES (271, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 11:32:39');
INSERT INTO `sys_logininfor` VALUES (272, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '退出成功', '2026-10-19 11:41:19');
INSERT INTO `sys_logininfor` VALUES (273, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 11:41:33');
INSERT INTO `sys_logininfor` VALUES (274, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 11:41:50');
INSERT INTO `sys_logininfor` VALUES (275, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 11:57:13');
INSERT INTO `sys_logininfor` VALUES (276, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 14:08:32');
INSERT INTO `sys_logininfor` VALUES (277, '13900001111', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 14:09:12');
INSERT INTO `sys_logininfor` VALUES (278, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 14:38:27');
INSERT INTO `sys_logininfor` VALUES (279, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 14:38:42');
INSERT INTO `sys_logininfor` VALUES (280, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 14:47:36');
INSERT INTO `sys_logininfor` VALUES (281, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 14:47:47');
INSERT INTO `sys_logininfor` VALUES (282, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 14:49:45');
INSERT INTO `sys_logininfor` VALUES (283, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-19 14:52:58');
INSERT INTO `sys_logininfor` VALUES (284, '13900000001', '47.128.243.133', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 16:46:59');
INSERT INTO `sys_logininfor` VALUES (285, '13900000001', '47.128.243.133', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-19 16:47:10');
INSERT INTO `sys_logininfor` VALUES (286, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '登录成功', '2026-10-20 12:51:33');
INSERT INTO `sys_logininfor` VALUES (287, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-20 12:52:41');
INSERT INTO `sys_logininfor` VALUES (288, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-20 13:18:00');
INSERT INTO `sys_logininfor` VALUES (289, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-20 14:13:44');
INSERT INTO `sys_logininfor` VALUES (290, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-20 14:20:29');
INSERT INTO `sys_logininfor` VALUES (291, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-20 14:27:33');
INSERT INTO `sys_logininfor` VALUES (292, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-20 14:27:51');
INSERT INTO `sys_logininfor` VALUES (293, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-20 14:28:32');
INSERT INTO `sys_logininfor` VALUES (294, '13900139001', '58.16.41.98', 'XX XX', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '登录成功', '2026-10-20 14:39:24');
INSERT INTO `sys_logininfor` VALUES (295, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-20 14:43:01');
INSERT INTO `sys_logininfor` VALUES (296, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-20 14:55:52');
INSERT INTO `sys_logininfor` VALUES (297, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-20 15:04:48');
INSERT INTO `sys_logininfor` VALUES (298, '13900139001', '58.16.41.98', 'XX XX', 'WindowsPowerShell 5.1.26100.6584', 'Windows 10.0', '0', '登录成功', '2026-10-20 17:14:48');
INSERT INTO `sys_logininfor` VALUES (299, 'eduadmin', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '1', '密码输入错误1次', '2026-10-20 17:23:28');
INSERT INTO `sys_logininfor` VALUES (300, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-20 17:36:25');
INSERT INTO `sys_logininfor` VALUES (301, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-20 17:36:32');
INSERT INTO `sys_logininfor` VALUES (302, 'admin', '54.251.198.55', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-21 09:44:08');
INSERT INTO `sys_logininfor` VALUES (303, 'admin', '54.251.198.55', 'XX XX', 'Edge 142', 'Windows >=10', '1', '验证码错误', '2026-10-21 09:44:19');
INSERT INTO `sys_logininfor` VALUES (304, 'admin', '54.251.198.55', 'XX XX', 'Edge 142', 'Windows >=10', '0', '退出成功', '2026-10-21 09:48:53');
INSERT INTO `sys_logininfor` VALUES (305, 'admin', '54.251.198.55', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-21 09:49:10');
INSERT INTO `sys_logininfor` VALUES (306, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-21 09:55:09');
INSERT INTO `sys_logininfor` VALUES (307, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-21 09:55:58');
INSERT INTO `sys_logininfor` VALUES (308, '13900000001', '54.251.198.55', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-21 09:56:54');
INSERT INTO `sys_logininfor` VALUES (309, '13900000001', '54.251.198.55', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-21 10:10:13');
INSERT INTO `sys_logininfor` VALUES (310, '13900000001', '54.251.198.55', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-21 10:10:39');
INSERT INTO `sys_logininfor` VALUES (311, '13900000001', '54.251.198.55', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-21 10:29:23');
INSERT INTO `sys_logininfor` VALUES (312, '13900000001', '54.251.198.55', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-21 10:31:51');
INSERT INTO `sys_logininfor` VALUES (313, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-21 11:04:06');
INSERT INTO `sys_logininfor` VALUES (314, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-21 11:15:28');
INSERT INTO `sys_logininfor` VALUES (315, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-22 09:59:05');
INSERT INTO `sys_logininfor` VALUES (316, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-22 10:09:09');
INSERT INTO `sys_logininfor` VALUES (317, 'admin', '42.200.173.215', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-22 10:50:00');
INSERT INTO `sys_logininfor` VALUES (318, '13900000001', '42.200.173.215', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-22 10:50:28');
INSERT INTO `sys_logininfor` VALUES (319, '13900000001', '42.200.173.215', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-22 10:55:02');
INSERT INTO `sys_logininfor` VALUES (320, '13900000001', '42.200.173.215', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-22 10:57:33');
INSERT INTO `sys_logininfor` VALUES (321, '13900000001', '42.200.173.215', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-22 10:58:07');
INSERT INTO `sys_logininfor` VALUES (322, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-22 14:15:38');
INSERT INTO `sys_logininfor` VALUES (323, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-22 14:47:11');
INSERT INTO `sys_logininfor` VALUES (324, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-22 14:47:29');
INSERT INTO `sys_logininfor` VALUES (325, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-22 14:48:33');
INSERT INTO `sys_logininfor` VALUES (326, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-22 14:49:06');
INSERT INTO `sys_logininfor` VALUES (327, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-22 15:40:29');
INSERT INTO `sys_logininfor` VALUES (328, '13900139001', '58.16.41.98', 'XX XX', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-22 15:51:51');
INSERT INTO `sys_logininfor` VALUES (329, '13900139001', '58.16.41.98', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-22 15:53:25');
INSERT INTO `sys_logininfor` VALUES (330, '13900139001', '58.16.41.98', 'XX XX', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-22 15:54:50');
INSERT INTO `sys_logininfor` VALUES (331, '13900139001', '58.16.41.98', 'XX XX', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-22 15:54:57');
INSERT INTO `sys_logininfor` VALUES (332, '13900139001', '58.16.41.98', 'XX XX', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-22 15:55:08');
INSERT INTO `sys_logininfor` VALUES (333, '13900139001', '58.16.41.98', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-22 15:58:10');
INSERT INTO `sys_logininfor` VALUES (334, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-22 16:11:37');
INSERT INTO `sys_logininfor` VALUES (335, '13900139001', '220.197.72.77', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-22 16:17:07');
INSERT INTO `sys_logininfor` VALUES (336, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-22 16:22:14');
INSERT INTO `sys_logininfor` VALUES (337, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-22 16:22:30');
INSERT INTO `sys_logininfor` VALUES (338, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-22 16:22:37');
INSERT INTO `sys_logininfor` VALUES (339, '13900139001', '192.168.100.110', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-22 16:28:46');
INSERT INTO `sys_logininfor` VALUES (340, '13900139001', '192.168.100.110', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-22 17:47:33');
INSERT INTO `sys_logininfor` VALUES (341, '13900139001', '192.168.100.110', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-22 17:56:00');
INSERT INTO `sys_logininfor` VALUES (342, 'eduadmin', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '1', '密码输入错误1次', '2026-10-23 10:13:33');
INSERT INTO `sys_logininfor` VALUES (343, 'eduadmin', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '1', '密码输入错误2次', '2026-10-23 10:14:19');
INSERT INTO `sys_logininfor` VALUES (344, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '注册成功', '2026-10-23 10:14:33');
INSERT INTO `sys_logininfor` VALUES (345, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-23 10:14:41');
INSERT INTO `sys_logininfor` VALUES (346, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-23 10:25:53');
INSERT INTO `sys_logininfor` VALUES (347, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-23 10:36:32');
INSERT INTO `sys_logininfor` VALUES (348, '13888888888', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '注册成功', '2026-10-23 10:45:46');
INSERT INTO `sys_logininfor` VALUES (349, '13888888888', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-23 10:46:03');
INSERT INTO `sys_logininfor` VALUES (350, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-23 10:50:41');
INSERT INTO `sys_logininfor` VALUES (351, 'admin', '47.128.243.133', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-23 11:16:17');
INSERT INTO `sys_logininfor` VALUES (352, '13900000001', '47.128.243.133', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-23 11:16:26');
INSERT INTO `sys_logininfor` VALUES (353, '13900000001', '47.128.243.133', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-23 11:20:23');
INSERT INTO `sys_logininfor` VALUES (354, '13900000001', '47.128.243.133', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-23 11:20:33');
INSERT INTO `sys_logininfor` VALUES (355, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-26 20:25:43');
INSERT INTO `sys_logininfor` VALUES (356, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-26 20:52:49');
INSERT INTO `sys_logininfor` VALUES (357, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-26 21:25:10');
INSERT INTO `sys_logininfor` VALUES (358, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-26 21:49:52');
INSERT INTO `sys_logininfor` VALUES (359, 'admin', '47.102.144.147', 'XX XX', 'Chrome 126', 'Windows10', '1', '验证码错误', '2026-10-27 04:33:28');
INSERT INTO `sys_logininfor` VALUES (360, 'admin', '47.102.144.147', 'XX XX', 'Chrome 126', 'Windows10', '1', '验证码错误', '2026-10-27 04:33:29');
INSERT INTO `sys_logininfor` VALUES (361, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 09:06:47');
INSERT INTO `sys_logininfor` VALUES (362, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 09:27:35');
INSERT INTO `sys_logininfor` VALUES (363, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 09:27:36');
INSERT INTO `sys_logininfor` VALUES (364, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 09:28:22');
INSERT INTO `sys_logininfor` VALUES (365, '13900000001', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-27 09:32:17');
INSERT INTO `sys_logininfor` VALUES (366, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-27 09:34:33');
INSERT INTO `sys_logininfor` VALUES (367, 'eduadmin', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '1', '密码输入错误1次', '2026-10-27 09:35:08');
INSERT INTO `sys_logininfor` VALUES (368, 'eduadmin', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '1', '密码输入错误2次', '2026-10-27 09:35:15');
INSERT INTO `sys_logininfor` VALUES (369, '13900000000', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '1', '用户不存在/密码错误', '2026-10-27 09:35:15');
INSERT INTO `sys_logininfor` VALUES (370, 'eduadmin', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '1', '密码输入错误3次', '2026-10-27 09:35:15');
INSERT INTO `sys_logininfor` VALUES (371, '13900001234', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '注册成功', '2026-10-27 09:36:24');
INSERT INTO `sys_logininfor` VALUES (372, '13900001234', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 09:36:24');
INSERT INTO `sys_logininfor` VALUES (373, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 09:37:26');
INSERT INTO `sys_logininfor` VALUES (374, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 09:41:06');
INSERT INTO `sys_logininfor` VALUES (375, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 09:41:27');
INSERT INTO `sys_logininfor` VALUES (376, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-27 09:41:41');
INSERT INTO `sys_logininfor` VALUES (377, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-27 09:53:19');
INSERT INTO `sys_logininfor` VALUES (378, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-10-27 09:59:55');
INSERT INTO `sys_logininfor` VALUES (379, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 10:05:44');
INSERT INTO `sys_logininfor` VALUES (380, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 10:12:03');
INSERT INTO `sys_logininfor` VALUES (381, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 10:12:58');
INSERT INTO `sys_logininfor` VALUES (382, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 10:15:45');
INSERT INTO `sys_logininfor` VALUES (383, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-27 10:40:22');
INSERT INTO `sys_logininfor` VALUES (384, 'admin', '43.206.102.56', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 10:41:28');
INSERT INTO `sys_logininfor` VALUES (385, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 10:41:37');
INSERT INTO `sys_logininfor` VALUES (386, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 10:41:56');
INSERT INTO `sys_logininfor` VALUES (387, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 10:44:44');
INSERT INTO `sys_logininfor` VALUES (388, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 10:49:31');
INSERT INTO `sys_logininfor` VALUES (389, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 10:59:15');
INSERT INTO `sys_logininfor` VALUES (390, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-27 11:01:17');
INSERT INTO `sys_logininfor` VALUES (391, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-27 11:01:22');
INSERT INTO `sys_logininfor` VALUES (392, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-27 11:01:23');
INSERT INTO `sys_logininfor` VALUES (393, '13900000001', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-27 11:02:19');
INSERT INTO `sys_logininfor` VALUES (394, '13900139001', '58.16.41.98', 'XX XX', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 11:08:31');
INSERT INTO `sys_logininfor` VALUES (395, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 11:08:41');
INSERT INTO `sys_logininfor` VALUES (396, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 11:44:28');
INSERT INTO `sys_logininfor` VALUES (397, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:01:30');
INSERT INTO `sys_logininfor` VALUES (398, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:01:35');
INSERT INTO `sys_logininfor` VALUES (399, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:01:36');
INSERT INTO `sys_logininfor` VALUES (400, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:01:36');
INSERT INTO `sys_logininfor` VALUES (401, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:01:36');
INSERT INTO `sys_logininfor` VALUES (402, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 14:15:21');
INSERT INTO `sys_logininfor` VALUES (403, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:19:19');
INSERT INTO `sys_logininfor` VALUES (404, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:19:19');
INSERT INTO `sys_logininfor` VALUES (405, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '1', '密码输入错误1次', '2026-10-27 14:19:19');
INSERT INTO `sys_logininfor` VALUES (406, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:19:19');
INSERT INTO `sys_logininfor` VALUES (407, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:19:20');
INSERT INTO `sys_logininfor` VALUES (408, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 14:19:20');
INSERT INTO `sys_logininfor` VALUES (409, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 14:33:30');
INSERT INTO `sys_logininfor` VALUES (410, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 14:45:19');
INSERT INTO `sys_logininfor` VALUES (411, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 14:45:48');
INSERT INTO `sys_logininfor` VALUES (412, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 14:54:04');
INSERT INTO `sys_logininfor` VALUES (413, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 14:59:33');
INSERT INTO `sys_logininfor` VALUES (414, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 15:01:14');
INSERT INTO `sys_logininfor` VALUES (415, '13900000001', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-27 15:19:20');
INSERT INTO `sys_logininfor` VALUES (416, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-10-27 15:20:53');
INSERT INTO `sys_logininfor` VALUES (417, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-27 15:32:19');
INSERT INTO `sys_logininfor` VALUES (418, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 15:47:45');
INSERT INTO `sys_logininfor` VALUES (419, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-27 15:50:43');
INSERT INTO `sys_logininfor` VALUES (420, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 16:04:58');
INSERT INTO `sys_logininfor` VALUES (421, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 16:05:18');
INSERT INTO `sys_logininfor` VALUES (422, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-10-27 16:51:44');
INSERT INTO `sys_logininfor` VALUES (423, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 17:04:11');
INSERT INTO `sys_logininfor` VALUES (424, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-10-27 17:23:34');
INSERT INTO `sys_logininfor` VALUES (425, 'admin', '35.79.25.92', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 17:29:59');
INSERT INTO `sys_logininfor` VALUES (426, '13900000001', '35.79.25.92', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 17:30:08');
INSERT INTO `sys_logininfor` VALUES (427, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 17:31:13');
INSERT INTO `sys_logininfor` VALUES (428, '13900000001', '35.79.25.92', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-27 17:37:49');
INSERT INTO `sys_logininfor` VALUES (429, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 17:37:56');
INSERT INTO `sys_logininfor` VALUES (430, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-27 17:55:19');
INSERT INTO `sys_logininfor` VALUES (431, '13900000009', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '注册成功', '2026-10-27 17:56:45');
INSERT INTO `sys_logininfor` VALUES (432, '13900000009', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-27 17:56:59');
INSERT INTO `sys_logininfor` VALUES (433, '13900000001', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-27 18:46:58');
INSERT INTO `sys_logininfor` VALUES (434, '13900000001', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-27 18:59:23');
INSERT INTO `sys_logininfor` VALUES (435, '13900000009', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-27 18:59:48');
INSERT INTO `sys_logininfor` VALUES (436, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-28 09:06:38');
INSERT INTO `sys_logininfor` VALUES (437, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-28 09:07:40');
INSERT INTO `sys_logininfor` VALUES (438, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 09:24:13');
INSERT INTO `sys_logininfor` VALUES (439, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-28 09:28:43');
INSERT INTO `sys_logininfor` VALUES (440, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-10-28 09:29:29');
INSERT INTO `sys_logininfor` VALUES (441, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 09:36:45');
INSERT INTO `sys_logininfor` VALUES (442, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-28 09:45:06');
INSERT INTO `sys_logininfor` VALUES (443, '13900000001', '43.142.9.214', 'XX XX', 'Curl 7.81.0', '', '0', '登录成功', '2026-10-28 09:47:32');
INSERT INTO `sys_logininfor` VALUES (444, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:18:34');
INSERT INTO `sys_logininfor` VALUES (445, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:20:13');
INSERT INTO `sys_logininfor` VALUES (446, '13900139001', '58.16.41.98', 'XX XX', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:20:22');
INSERT INTO `sys_logininfor` VALUES (447, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:33:21');
INSERT INTO `sys_logininfor` VALUES (448, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:38:53');
INSERT INTO `sys_logininfor` VALUES (449, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:38:55');
INSERT INTO `sys_logininfor` VALUES (450, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:40:02');
INSERT INTO `sys_logininfor` VALUES (451, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:40:17');
INSERT INTO `sys_logininfor` VALUES (452, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-28 10:40:30');
INSERT INTO `sys_logininfor` VALUES (453, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-28 10:45:57');
INSERT INTO `sys_logininfor` VALUES (454, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-28 10:46:01');
INSERT INTO `sys_logininfor` VALUES (455, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-28 10:46:13');
INSERT INTO `sys_logininfor` VALUES (456, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-28 10:46:33');
INSERT INTO `sys_logininfor` VALUES (457, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-28 10:46:38');
INSERT INTO `sys_logininfor` VALUES (458, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-28 10:50:41');
INSERT INTO `sys_logininfor` VALUES (459, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:54:01');
INSERT INTO `sys_logininfor` VALUES (460, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-10-28 10:55:24');
INSERT INTO `sys_logininfor` VALUES (461, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 10:55:31');
INSERT INTO `sys_logininfor` VALUES (462, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-10-28 11:33:54');
INSERT INTO `sys_logininfor` VALUES (463, '13900000009', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-28 11:34:41');
INSERT INTO `sys_logininfor` VALUES (464, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 11:44:58');
INSERT INTO `sys_logininfor` VALUES (465, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 11:45:14');
INSERT INTO `sys_logininfor` VALUES (466, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 14:05:04');
INSERT INTO `sys_logininfor` VALUES (467, '13900000001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 14:05:19');
INSERT INTO `sys_logininfor` VALUES (468, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 14:27:14');
INSERT INTO `sys_logininfor` VALUES (469, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 14:28:20');
INSERT INTO `sys_logininfor` VALUES (470, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 14:32:23');
INSERT INTO `sys_logininfor` VALUES (471, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 14:35:08');
INSERT INTO `sys_logininfor` VALUES (472, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 14:36:01');
INSERT INTO `sys_logininfor` VALUES (473, '13900000001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-28 14:47:54');
INSERT INTO `sys_logininfor` VALUES (474, '13638010667', '192.168.88.3', '内网IP', 'Projectapp2 1', 'iOS 18.?', '1', '用户不存在/密码错误', '2026-10-28 15:03:16');
INSERT INTO `sys_logininfor` VALUES (475, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 15:13:55');
INSERT INTO `sys_logininfor` VALUES (476, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 15:28:34');
INSERT INTO `sys_logininfor` VALUES (477, '13900000001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 15:35:04');
INSERT INTO `sys_logininfor` VALUES (478, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 15:36:15');
INSERT INTO `sys_logininfor` VALUES (479, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 15:39:34');
INSERT INTO `sys_logininfor` VALUES (480, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-28 15:40:38');
INSERT INTO `sys_logininfor` VALUES (481, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-28 15:41:35');
INSERT INTO `sys_logininfor` VALUES (482, '13900000001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 15:43:28');
INSERT INTO `sys_logininfor` VALUES (483, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 15:49:27');
INSERT INTO `sys_logininfor` VALUES (484, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-28 15:57:41');
INSERT INTO `sys_logininfor` VALUES (485, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-28 16:05:21');
INSERT INTO `sys_logininfor` VALUES (486, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 16:24:42');
INSERT INTO `sys_logininfor` VALUES (487, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 16:30:03');
INSERT INTO `sys_logininfor` VALUES (488, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-10-28 16:43:47');
INSERT INTO `sys_logininfor` VALUES (489, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 16:49:05');
INSERT INTO `sys_logininfor` VALUES (490, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 16:51:06');
INSERT INTO `sys_logininfor` VALUES (491, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 16:52:55');
INSERT INTO `sys_logininfor` VALUES (492, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 16:53:07');
INSERT INTO `sys_logininfor` VALUES (493, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 16:53:21');
INSERT INTO `sys_logininfor` VALUES (494, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 16:57:55');
INSERT INTO `sys_logininfor` VALUES (495, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 16:58:45');
INSERT INTO `sys_logininfor` VALUES (496, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 17:03:01');
INSERT INTO `sys_logininfor` VALUES (497, '13900000001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 17:11:28');
INSERT INTO `sys_logininfor` VALUES (498, '13900000001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 17:11:35');
INSERT INTO `sys_logininfor` VALUES (499, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 17:11:45');
INSERT INTO `sys_logininfor` VALUES (500, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 17:15:28');
INSERT INTO `sys_logininfor` VALUES (501, '13900000001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 17:15:29');
INSERT INTO `sys_logininfor` VALUES (502, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 17:23:35');
INSERT INTO `sys_logininfor` VALUES (503, '13900000001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 17:28:05');
INSERT INTO `sys_logininfor` VALUES (504, '13900139001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-28 17:34:07');
INSERT INTO `sys_logininfor` VALUES (505, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-28 17:42:17');
INSERT INTO `sys_logininfor` VALUES (506, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-28 17:42:23');
INSERT INTO `sys_logininfor` VALUES (507, '13900139001', '127.0.0.1', '内网IP', 'WindowsPowerShell 5.1.26100.9711', 'Windows 10.0', '0', '登录成功', '2026-10-28 17:43:28');
INSERT INTO `sys_logininfor` VALUES (508, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-28 17:44:00');
INSERT INTO `sys_logininfor` VALUES (509, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 17:54:03');
INSERT INTO `sys_logininfor` VALUES (510, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 19:30:20');
INSERT INTO `sys_logininfor` VALUES (511, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 19:31:37');
INSERT INTO `sys_logininfor` VALUES (512, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 19:31:55');
INSERT INTO `sys_logininfor` VALUES (513, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 19:42:20');
INSERT INTO `sys_logininfor` VALUES (514, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 19:42:36');
INSERT INTO `sys_logininfor` VALUES (515, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 19:43:03');
INSERT INTO `sys_logininfor` VALUES (516, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 19:51:54');
INSERT INTO `sys_logininfor` VALUES (517, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 21:12:27');
INSERT INTO `sys_logininfor` VALUES (518, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 21:13:11');
INSERT INTO `sys_logininfor` VALUES (519, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 21:25:20');
INSERT INTO `sys_logininfor` VALUES (520, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 21:38:07');
INSERT INTO `sys_logininfor` VALUES (521, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 23:51:23');
INSERT INTO `sys_logininfor` VALUES (522, '13911113333', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '注册成功', '2026-10-28 23:51:55');
INSERT INTO `sys_logininfor` VALUES (523, '13911113333', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-28 23:51:55');
INSERT INTO `sys_logininfor` VALUES (524, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-29 00:17:19');
INSERT INTO `sys_logininfor` VALUES (525, 'admin', '176.65.148.94', 'XX XX', 'Chrome 106', 'Windows10', '1', '验证码错误', '2026-10-29 00:33:19');
INSERT INTO `sys_logininfor` VALUES (526, '13911113333', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-29 00:40:16');
INSERT INTO `sys_logininfor` VALUES (527, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-29 09:08:23');
INSERT INTO `sys_logininfor` VALUES (528, '13911112222', '192.168.88.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-10-29 09:11:25');
INSERT INTO `sys_logininfor` VALUES (529, '13911112222', '192.168.88.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-10-29 09:15:23');
INSERT INTO `sys_logininfor` VALUES (530, '13911112222', '192.168.88.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-10-29 09:15:39');
INSERT INTO `sys_logininfor` VALUES (531, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-29 09:25:19');
INSERT INTO `sys_logininfor` VALUES (532, '13900000009', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '1', '密码输入错误1次', '2026-10-29 10:20:51');
INSERT INTO `sys_logininfor` VALUES (533, '13900000009', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-29 10:20:57');
INSERT INTO `sys_logininfor` VALUES (534, '13900000009', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-29 10:21:48');
INSERT INTO `sys_logininfor` VALUES (535, '13911112222', '192.168.88.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-10-29 10:46:02');
INSERT INTO `sys_logininfor` VALUES (536, '13911112222', '192.168.88.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-10-29 10:55:54');
INSERT INTO `sys_logininfor` VALUES (537, '13911112222', '192.168.88.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-10-29 10:57:48');
INSERT INTO `sys_logininfor` VALUES (538, '13911112222', '192.168.88.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-10-29 10:58:26');
INSERT INTO `sys_logininfor` VALUES (539, '13900000009', '192.168.170.128', '内网IP', 'Projectapp2 1', 'iOS 26.0', '0', '登录成功', '2026-10-29 11:06:25');
INSERT INTO `sys_logininfor` VALUES (540, '13800138000', '192.168.170.1', '内网IP', 'Curl 8.22.0', '', '1', '用户不存在/密码错误', '2026-10-29 11:25:31');
INSERT INTO `sys_logininfor` VALUES (541, '13900000001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-29 11:46:09');
INSERT INTO `sys_logininfor` VALUES (542, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 13:53:35');
INSERT INTO `sys_logininfor` VALUES (543, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-29 13:56:35');
INSERT INTO `sys_logininfor` VALUES (544, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:02:39');
INSERT INTO `sys_logininfor` VALUES (545, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:11:21');
INSERT INTO `sys_logininfor` VALUES (546, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:11:42');
INSERT INTO `sys_logininfor` VALUES (547, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:12:03');
INSERT INTO `sys_logininfor` VALUES (548, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:12:24');
INSERT INTO `sys_logininfor` VALUES (549, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:12:35');
INSERT INTO `sys_logininfor` VALUES (550, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:13:58');
INSERT INTO `sys_logininfor` VALUES (551, '13900001111', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:14:17');
INSERT INTO `sys_logininfor` VALUES (552, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:14:35');
INSERT INTO `sys_logininfor` VALUES (553, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:18:50');
INSERT INTO `sys_logininfor` VALUES (554, '13090139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '1', '用户不存在/密码错误', '2026-10-29 14:19:18');
INSERT INTO `sys_logininfor` VALUES (555, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-29 14:19:27');
INSERT INTO `sys_logininfor` VALUES (556, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:23:57');
INSERT INTO `sys_logininfor` VALUES (557, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:24:04');
INSERT INTO `sys_logininfor` VALUES (558, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:24:13');
INSERT INTO `sys_logininfor` VALUES (559, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:30:29');
INSERT INTO `sys_logininfor` VALUES (560, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:30:42');
INSERT INTO `sys_logininfor` VALUES (561, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:30:52');
INSERT INTO `sys_logininfor` VALUES (562, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:34:59');
INSERT INTO `sys_logininfor` VALUES (563, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:35:07');
INSERT INTO `sys_logininfor` VALUES (564, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-10-29 14:35:16');
INSERT INTO `sys_logininfor` VALUES (565, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:35:42');
INSERT INTO `sys_logininfor` VALUES (566, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:35:56');
INSERT INTO `sys_logininfor` VALUES (567, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:36:39');
INSERT INTO `sys_logininfor` VALUES (568, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:37:35');
INSERT INTO `sys_logininfor` VALUES (569, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:37:48');
INSERT INTO `sys_logininfor` VALUES (570, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:38:02');
INSERT INTO `sys_logininfor` VALUES (571, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:38:11');
INSERT INTO `sys_logininfor` VALUES (572, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:38:22');
INSERT INTO `sys_logininfor` VALUES (573, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:38:49');
INSERT INTO `sys_logininfor` VALUES (574, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:38:59');
INSERT INTO `sys_logininfor` VALUES (575, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:42:59');
INSERT INTO `sys_logininfor` VALUES (576, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:43:09');
INSERT INTO `sys_logininfor` VALUES (577, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:46:21');
INSERT INTO `sys_logininfor` VALUES (578, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:51:31');
INSERT INTO `sys_logininfor` VALUES (579, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:58:18');
INSERT INTO `sys_logininfor` VALUES (580, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:59:20');
INSERT INTO `sys_logininfor` VALUES (581, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 14:59:34');
INSERT INTO `sys_logininfor` VALUES (582, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 15:06:01');
INSERT INTO `sys_logininfor` VALUES (583, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '1', '密码输入错误1次', '2026-10-29 15:13:45');
INSERT INTO `sys_logininfor` VALUES (584, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 15:14:10');
INSERT INTO `sys_logininfor` VALUES (585, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 15:14:16');
INSERT INTO `sys_logininfor` VALUES (586, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-29 15:17:30');
INSERT INTO `sys_logininfor` VALUES (587, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 15:20:35');
INSERT INTO `sys_logininfor` VALUES (588, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-10-29 15:35:48');
INSERT INTO `sys_logininfor` VALUES (589, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 15:48:34');
INSERT INTO `sys_logininfor` VALUES (590, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-10-29 16:05:37');
INSERT INTO `sys_logininfor` VALUES (591, '13900000001', '127.0.0.1', '内网IP', 'Curl 7.71.1', '', '0', '登录成功', '2026-10-29 16:08:21');
INSERT INTO `sys_logininfor` VALUES (592, 'eduadmin', '192.168.170.1', '内网IP', 'Curl 8.22.0', '', '1', '密码输入错误1次', '2026-10-29 20:40:52');
INSERT INTO `sys_logininfor` VALUES (593, '13911112222', '192.168.170.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-29 20:41:01');
INSERT INTO `sys_logininfor` VALUES (594, 'admin', '111.60.72.67', 'XX XX', 'Chrome 120', 'Windows10', '1', '验证码错误', '2026-10-29 22:47:37');
INSERT INTO `sys_logininfor` VALUES (595, '13900000009', '192.168.170.129', '内网IP', 'Projectapp2 1', 'iOS 18.?', '0', '登录成功', '2026-10-30 09:49:18');
INSERT INTO `sys_logininfor` VALUES (596, 'admin', '56.10.179.194', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-30 09:50:30');
INSERT INTO `sys_logininfor` VALUES (597, '13900000001', '56.10.179.194', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-30 09:50:37');
INSERT INTO `sys_logininfor` VALUES (598, '13900000001', '192.168.170.129', '内网IP', 'Projectapp2 1', 'iOS 18.?', '0', '登录成功', '2026-10-30 09:51:52');
INSERT INTO `sys_logininfor` VALUES (599, '13900000001', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-30 09:57:55');
INSERT INTO `sys_logininfor` VALUES (600, '13900000001', '56.10.179.194', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-30 10:06:28');
INSERT INTO `sys_logininfor` VALUES (601, '13900001111', '56.10.179.194', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-30 10:06:28');
INSERT INTO `sys_logininfor` VALUES (602, '13900007777', '56.10.179.194', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-30 10:06:28');
INSERT INTO `sys_logininfor` VALUES (603, '13900000001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-10-30 10:34:44');
INSERT INTO `sys_logininfor` VALUES (604, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-30 10:39:20');
INSERT INTO `sys_logininfor` VALUES (605, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-30 12:41:12');
INSERT INTO `sys_logininfor` VALUES (606, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-10-30 12:41:16');
INSERT INTO `sys_logininfor` VALUES (607, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '1', '验证码错误', '2026-10-30 14:03:22');
INSERT INTO `sys_logininfor` VALUES (608, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-30 14:03:25');
INSERT INTO `sys_logininfor` VALUES (609, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-10-30 14:54:40');
INSERT INTO `sys_logininfor` VALUES (610, '13900000001', '192.168.170.129', '内网IP', 'Projectapp2 1', 'iOS 18.?', '0', '登录成功', '2026-10-30 15:26:18');
INSERT INTO `sys_logininfor` VALUES (611, 'admin', '54.255.140.13', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-10-30 16:19:43');
INSERT INTO `sys_logininfor` VALUES (612, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-10-30 17:08:45');
INSERT INTO `sys_logininfor` VALUES (613, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-02 09:27:42');
INSERT INTO `sys_logininfor` VALUES (614, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:29:14');
INSERT INTO `sys_logininfor` VALUES (615, '13900000001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-02 09:30:29');
INSERT INTO `sys_logininfor` VALUES (616, 'admin', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-02 09:34:27');
INSERT INTO `sys_logininfor` VALUES (617, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:37:55');
INSERT INTO `sys_logininfor` VALUES (618, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:38:18');
INSERT INTO `sys_logininfor` VALUES (619, '13900001111', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:42:28');
INSERT INTO `sys_logininfor` VALUES (620, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:42:29');
INSERT INTO `sys_logininfor` VALUES (621, '13900001111', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:45:48');
INSERT INTO `sys_logininfor` VALUES (622, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:45:49');
INSERT INTO `sys_logininfor` VALUES (623, '13900001111', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:47:10');
INSERT INTO `sys_logininfor` VALUES (624, '13900001111', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:47:29');
INSERT INTO `sys_logininfor` VALUES (625, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:51:55');
INSERT INTO `sys_logininfor` VALUES (626, '13900001111', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:52:06');
INSERT INTO `sys_logininfor` VALUES (627, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-11-02 09:52:07');
INSERT INTO `sys_logininfor` VALUES (628, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 09:52:07');
INSERT INTO `sys_logininfor` VALUES (629, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 10:01:30');
INSERT INTO `sys_logininfor` VALUES (630, 'admin', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-02 10:37:56');
INSERT INTO `sys_logininfor` VALUES (631, '13900000001', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-02 10:38:02');
INSERT INTO `sys_logininfor` VALUES (632, '13900001111', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-02 10:38:02');
INSERT INTO `sys_logininfor` VALUES (633, '13900000001', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-02 10:38:05');
INSERT INTO `sys_logininfor` VALUES (634, '13900000001', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-02 10:53:18');
INSERT INTO `sys_logininfor` VALUES (635, '13900001111', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-02 10:53:18');
INSERT INTO `sys_logininfor` VALUES (636, '13900000001', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-02 10:53:19');
INSERT INTO `sys_logininfor` VALUES (637, '13900000001', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '1', '密码输入错误1次', '2026-11-02 10:55:28');
INSERT INTO `sys_logininfor` VALUES (638, '13900000001', '18.140.50.255', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-02 10:56:26');
INSERT INTO `sys_logininfor` VALUES (639, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-02 14:52:13');
INSERT INTO `sys_logininfor` VALUES (640, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-02 15:42:17');
INSERT INTO `sys_logininfor` VALUES (641, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 15:49:32');
INSERT INTO `sys_logininfor` VALUES (642, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 15:49:46');
INSERT INTO `sys_logininfor` VALUES (643, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 15:50:53');
INSERT INTO `sys_logininfor` VALUES (644, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '1', '验证码错误', '2026-11-02 16:17:59');
INSERT INTO `sys_logininfor` VALUES (645, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 16:18:42');
INSERT INTO `sys_logininfor` VALUES (646, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 16:19:00');
INSERT INTO `sys_logininfor` VALUES (647, 'test01', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '1', '用户不存在/密码错误', '2026-11-02 16:19:05');
INSERT INTO `sys_logininfor` VALUES (648, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '1', '验证码错误', '2026-11-02 16:19:42');
INSERT INTO `sys_logininfor` VALUES (649, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 16:28:01');
INSERT INTO `sys_logininfor` VALUES (650, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-02 16:28:14');
INSERT INTO `sys_logininfor` VALUES (651, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '1', '验证码错误', '2026-11-02 16:28:45');
INSERT INTO `sys_logininfor` VALUES (652, NULL, '97.107.136.223', 'XX XX', 'Python-URLLIB3 2.8.0', '', '1', '验证码错误', '2026-11-04 02:51:55');
INSERT INTO `sys_logininfor` VALUES (653, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-04 09:54:40');
INSERT INTO `sys_logininfor` VALUES (654, 'admin', '127.0.0.1', '内网IP', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-11-04 14:48:31');
INSERT INTO `sys_logininfor` VALUES (655, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-04 17:11:42');
INSERT INTO `sys_logininfor` VALUES (656, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-04 17:11:42');
INSERT INTO `sys_logininfor` VALUES (657, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-04 17:28:07');
INSERT INTO `sys_logininfor` VALUES (658, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-04 17:32:25');
INSERT INTO `sys_logininfor` VALUES (659, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-04 17:33:29');
INSERT INTO `sys_logininfor` VALUES (660, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-04 17:34:15');
INSERT INTO `sys_logininfor` VALUES (661, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-04 17:34:44');
INSERT INTO `sys_logininfor` VALUES (662, 'eduadmin', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '1', '密码输入错误1次', '2026-11-04 21:33:01');
INSERT INTO `sys_logininfor` VALUES (663, 'admin', '47.116.137.84', 'XX XX', 'Netscape 5.0', '', '1', '验证码错误', '2026-11-05 07:39:12');
INSERT INTO `sys_logininfor` VALUES (664, 'admin', '47.116.137.84', 'XX XX', 'Netscape 5.0', '', '1', '验证码错误', '2026-11-05 07:39:12');
INSERT INTO `sys_logininfor` VALUES (665, 'admin', '47.116.137.84', 'XX XX', 'Netscape 5.0', '', '1', '验证码错误', '2026-11-05 07:39:12');
INSERT INTO `sys_logininfor` VALUES (666, 'admin', '47.116.137.84', 'XX XX', 'Netscape 5.0', '', '1', '验证码错误', '2026-11-05 07:39:12');
INSERT INTO `sys_logininfor` VALUES (667, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 09:50:10');
INSERT INTO `sys_logininfor` VALUES (668, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 09:50:26');
INSERT INTO `sys_logininfor` VALUES (669, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 10:13:11');
INSERT INTO `sys_logininfor` VALUES (670, '13911112222', '58.16.41.98', 'XX XX', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 14:04:28');
INSERT INTO `sys_logininfor` VALUES (671, '13911112222', '58.16.41.98', 'XX XX', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 14:04:35');
INSERT INTO `sys_logininfor` VALUES (672, '13911112222', '58.16.41.98', 'XX XX', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 14:04:35');
INSERT INTO `sys_logininfor` VALUES (673, '13911112222', '58.16.41.98', 'XX XX', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 14:04:44');
INSERT INTO `sys_logininfor` VALUES (674, '13911112222', '58.16.41.98', 'XX XX', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 14:20:47');
INSERT INTO `sys_logininfor` VALUES (675, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 14:44:42');
INSERT INTO `sys_logininfor` VALUES (676, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 15:39:55');
INSERT INTO `sys_logininfor` VALUES (677, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-05 16:04:46');
INSERT INTO `sys_logininfor` VALUES (678, '13911112222', '127.0.0.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-11-05 16:28:12');
INSERT INTO `sys_logininfor` VALUES (679, '13911112222', '127.0.0.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-11-05 16:28:37');
INSERT INTO `sys_logininfor` VALUES (680, '13911112222', '127.0.0.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-11-05 16:29:10');
INSERT INTO `sys_logininfor` VALUES (681, '13911112222', '127.0.0.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-11-05 16:29:57');
INSERT INTO `sys_logininfor` VALUES (682, '13911112222', '127.0.0.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-11-05 16:30:09');
INSERT INTO `sys_logininfor` VALUES (683, '13911112222', '127.0.0.1', '内网IP', 'Python-urllib 3.10', '', '0', '登录成功', '2026-11-05 16:30:32');
INSERT INTO `sys_logininfor` VALUES (684, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-06 09:18:52');
INSERT INTO `sys_logininfor` VALUES (685, '13900000001', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-06 09:56:18');
INSERT INTO `sys_logininfor` VALUES (686, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-06 11:59:34');
INSERT INTO `sys_logininfor` VALUES (687, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-06 14:01:47');
INSERT INTO `sys_logininfor` VALUES (688, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-06 14:52:59');
INSERT INTO `sys_logininfor` VALUES (689, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-06 14:53:08');
INSERT INTO `sys_logininfor` VALUES (690, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-06 14:53:15');
INSERT INTO `sys_logininfor` VALUES (691, '13113131313', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '注册成功', '2026-11-06 15:17:04');
INSERT INTO `sys_logininfor` VALUES (692, '13113131313', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-06 15:17:29');
INSERT INTO `sys_logininfor` VALUES (693, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-06 15:18:24');
INSERT INTO `sys_logininfor` VALUES (694, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-06 16:58:43');
INSERT INTO `sys_logininfor` VALUES (695, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-06 16:59:05');
INSERT INTO `sys_logininfor` VALUES (696, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-06 16:59:29');
INSERT INTO `sys_logininfor` VALUES (697, '13800000000', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '1', '用户不存在/密码错误', '2026-11-06 20:16:05');
INSERT INTO `sys_logininfor` VALUES (698, 'eduadmin', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '1', '密码输入错误1次', '2026-11-06 20:16:15');
INSERT INTO `sys_logininfor` VALUES (699, '13800000001', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '1', '用户不存在/密码错误', '2026-11-06 20:16:15');
INSERT INTO `sys_logininfor` VALUES (700, 'admin', '107.149.108.90', 'XX XX', 'Chrome 120', 'Windows >=10', '1', '验证码错误', '2026-11-07 06:53:07');
INSERT INTO `sys_logininfor` VALUES (701, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-09 08:57:30');
INSERT INTO `sys_logininfor` VALUES (702, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-09 09:02:30');
INSERT INTO `sys_logininfor` VALUES (703, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-09 09:15:41');
INSERT INTO `sys_logininfor` VALUES (704, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-09 09:18:59');
INSERT INTO `sys_logininfor` VALUES (705, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-09 09:23:04');
INSERT INTO `sys_logininfor` VALUES (706, '13911112222', '192.168.88.3', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-09 09:23:19');
INSERT INTO `sys_logininfor` VALUES (707, '13911112222', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-09 10:59:39');
INSERT INTO `sys_logininfor` VALUES (708, '13911113333', '192.168.88.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-09 10:59:40');
INSERT INTO `sys_logininfor` VALUES (709, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-09 11:00:26');
INSERT INTO `sys_logininfor` VALUES (710, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-09 11:00:39');
INSERT INTO `sys_logininfor` VALUES (711, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-09 11:10:37');
INSERT INTO `sys_logininfor` VALUES (712, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-09 11:10:44');
INSERT INTO `sys_logininfor` VALUES (713, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-09 11:10:55');
INSERT INTO `sys_logininfor` VALUES (714, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-09 11:25:21');
INSERT INTO `sys_logininfor` VALUES (715, 'admin', '127.0.0.1', '内网IP', 'Chrome 157', 'Windows10', '0', '登录成功', '2026-11-09 11:26:05');
INSERT INTO `sys_logininfor` VALUES (716, 'admin', '58.16.41.98', 'XX XX', 'Chrome 157', 'Windows10', '0', '登录成功', '2026-11-09 11:26:47');
INSERT INTO `sys_logininfor` VALUES (717, 'admin', '58.16.41.98', 'XX XX', 'Edge 156', 'Windows >=10', '0', '登录成功', '2026-11-09 11:27:24');
INSERT INTO `sys_logininfor` VALUES (718, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 09:18:28');
INSERT INTO `sys_logininfor` VALUES (719, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 09:20:59');
INSERT INTO `sys_logininfor` VALUES (720, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 09:33:36');
INSERT INTO `sys_logininfor` VALUES (721, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 09:39:39');
INSERT INTO `sys_logininfor` VALUES (722, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 09:39:40');
INSERT INTO `sys_logininfor` VALUES (723, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 09:40:06');
INSERT INTO `sys_logininfor` VALUES (724, 'admin', '58.16.41.98', 'XX XX', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-10 09:47:46');
INSERT INTO `sys_logininfor` VALUES (725, 'admin', '58.16.41.98', 'XX XX', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-10 09:51:06');
INSERT INTO `sys_logininfor` VALUES (726, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 10:08:00');
INSERT INTO `sys_logininfor` VALUES (727, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 10:14:37');
INSERT INTO `sys_logininfor` VALUES (728, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 11:19:08');
INSERT INTO `sys_logininfor` VALUES (729, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 11:21:34');
INSERT INTO `sys_logininfor` VALUES (730, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 11:40:30');
INSERT INTO `sys_logininfor` VALUES (731, 'eduadmin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-10 11:58:41');
INSERT INTO `sys_logininfor` VALUES (732, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-10 14:00:24');
INSERT INTO `sys_logininfor` VALUES (733, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 14:25:14');
INSERT INTO `sys_logininfor` VALUES (734, 'admin', '58.16.41.98', 'XX XX', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-10 14:27:25');
INSERT INTO `sys_logininfor` VALUES (735, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '1', '验证码错误', '2026-11-10 15:25:14');
INSERT INTO `sys_logininfor` VALUES (736, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '1', '密码输入错误1次', '2026-11-10 15:25:18');
INSERT INTO `sys_logininfor` VALUES (737, 'admin123', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '1', '用户不存在/密码错误', '2026-11-10 15:25:24');
INSERT INTO `sys_logininfor` VALUES (738, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-10 15:25:32');
INSERT INTO `sys_logininfor` VALUES (739, '13900000001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '1', '密码输入错误1次', '2026-11-10 15:50:41');
INSERT INTO `sys_logininfor` VALUES (740, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-10 15:51:00');
INSERT INTO `sys_logininfor` VALUES (741, '13900000001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-10 15:54:48');
INSERT INTO `sys_logininfor` VALUES (742, 'eduadmin', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '1', '密码输入错误1次', '2026-11-11 09:34:01');
INSERT INTO `sys_logininfor` VALUES (743, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '1', '验证码错误', '2026-11-11 09:38:51');
INSERT INTO `sys_logininfor` VALUES (744, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '1', '密码输入错误1次', '2026-11-11 09:38:53');
INSERT INTO `sys_logininfor` VALUES (745, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '1', '密码输入错误2次', '2026-11-11 09:38:59');
INSERT INTO `sys_logininfor` VALUES (746, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '1', '密码输入错误3次', '2026-11-11 09:39:06');
INSERT INTO `sys_logininfor` VALUES (747, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-11 09:39:18');
INSERT INTO `sys_logininfor` VALUES (748, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-11 09:39:44');
INSERT INTO `sys_logininfor` VALUES (749, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 09:57:14');
INSERT INTO `sys_logininfor` VALUES (750, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 09:58:18');
INSERT INTO `sys_logininfor` VALUES (751, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 10:09:23');
INSERT INTO `sys_logininfor` VALUES (752, '13900000009', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 10:30:55');
INSERT INTO `sys_logininfor` VALUES (753, '13900000009', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 10:32:26');
INSERT INTO `sys_logininfor` VALUES (754, '13900000009', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 10:32:40');
INSERT INTO `sys_logininfor` VALUES (755, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-11 10:48:53');
INSERT INTO `sys_logininfor` VALUES (756, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 10:59:52');
INSERT INTO `sys_logininfor` VALUES (757, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 11:04:04');
INSERT INTO `sys_logininfor` VALUES (758, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 11:04:05');
INSERT INTO `sys_logininfor` VALUES (759, 'admin', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-11 11:07:59');
INSERT INTO `sys_logininfor` VALUES (760, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 14:04:39');
INSERT INTO `sys_logininfor` VALUES (761, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 14:04:43');
INSERT INTO `sys_logininfor` VALUES (762, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 14:07:13');
INSERT INTO `sys_logininfor` VALUES (763, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 14:07:54');
INSERT INTO `sys_logininfor` VALUES (764, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-11 14:22:12');
INSERT INTO `sys_logininfor` VALUES (765, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '1', '验证码错误', '2026-11-11 14:29:34');
INSERT INTO `sys_logininfor` VALUES (766, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-11 14:29:45');
INSERT INTO `sys_logininfor` VALUES (767, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 15:31:34');
INSERT INTO `sys_logininfor` VALUES (768, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 15:33:04');
INSERT INTO `sys_logininfor` VALUES (769, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 15:39:32');
INSERT INTO `sys_logininfor` VALUES (770, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 15:44:26');
INSERT INTO `sys_logininfor` VALUES (771, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 15:53:45');
INSERT INTO `sys_logininfor` VALUES (772, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 15:57:27');
INSERT INTO `sys_logininfor` VALUES (773, '13911112222', '192.168.101.194', '内网IP', 'Curl 8.7.1', '', '1', '密码输入错误1次', '2026-11-11 15:58:41');
INSERT INTO `sys_logininfor` VALUES (774, '13911112222', '192.168.101.194', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-11 17:17:58');
INSERT INTO `sys_logininfor` VALUES (775, '13900009999', '58.16.41.98', 'XX XX', 'PowerShell 7.6.4', 'Windows 10.0', '0', '注册成功', '2026-11-12 14:42:16');
INSERT INTO `sys_logininfor` VALUES (776, '13900009999', '58.16.41.98', 'XX XX', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-12 14:42:29');
INSERT INTO `sys_logininfor` VALUES (777, '13900009999', '58.16.41.98', 'XX XX', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-12 14:43:16');
INSERT INTO `sys_logininfor` VALUES (778, '13900009999', '58.16.41.98', 'XX XX', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-12 14:43:49');
INSERT INTO `sys_logininfor` VALUES (779, '13900009999', '58.16.41.98', 'XX XX', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-12 14:44:04');
INSERT INTO `sys_logininfor` VALUES (780, '13900000001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-13 10:59:38');
INSERT INTO `sys_logininfor` VALUES (781, 'admin', '220.197.73.196', 'XX XX', 'Chrome 156', 'Windows10', '0', '登录成功', '2026-11-13 11:06:30');
INSERT INTO `sys_logininfor` VALUES (782, 'admin', '58.16.41.98', 'XX XX', 'Chrome 156', 'Windows10', '1', '验证码错误', '2026-11-13 13:56:44');
INSERT INTO `sys_logininfor` VALUES (783, 'admin', '58.16.41.98', 'XX XX', 'Chrome 156', 'Windows10', '0', '登录成功', '2026-11-13 13:57:15');
INSERT INTO `sys_logininfor` VALUES (784, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-13 14:19:18');
INSERT INTO `sys_logininfor` VALUES (785, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-11-13 18:12:09');
INSERT INTO `sys_logininfor` VALUES (786, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-11-13 18:33:10');
INSERT INTO `sys_logininfor` VALUES (787, '13900001234', '127.0.0.1', '内网IP', 'Curl 8.16.0', '', '1', '密码输入错误1次', '2026-11-16 09:06:28');
INSERT INTO `sys_logininfor` VALUES (788, '18800001111', '127.0.0.1', '内网IP', 'Curl 8.16.0', '', '0', '注册成功', '2026-11-16 09:06:36');
INSERT INTO `sys_logininfor` VALUES (789, '18800001111', '127.0.0.1', '内网IP', 'Curl 8.16.0', '', '0', '登录成功', '2026-11-16 09:06:37');
INSERT INTO `sys_logininfor` VALUES (790, '18800001111', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-16 09:06:51');
INSERT INTO `sys_logininfor` VALUES (791, '18800001111', '127.0.0.1', '内网IP', 'Curl 8.16.0', '', '0', '登录成功', '2026-11-16 09:10:20');
INSERT INTO `sys_logininfor` VALUES (792, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-16 14:35:28');
INSERT INTO `sys_logininfor` VALUES (793, 'admin', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '1', '验证码错误', '2026-11-16 14:45:36');
INSERT INTO `sys_logininfor` VALUES (794, 'test', '192.168.101.121', '内网IP', 'Curl 8.1.2', '', '1', '验证码错误', '2026-11-16 14:59:57');
INSERT INTO `sys_logininfor` VALUES (795, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-16 15:47:38');
INSERT INTO `sys_logininfor` VALUES (796, 'admin', '59.51.114.212', 'XX XX', 'Chrome 124', 'Windows10', '1', '验证码错误', '2026-11-16 16:59:59');
INSERT INTO `sys_logininfor` VALUES (797, 'a', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '1', '验证码错误', '2026-11-17 09:05:17');
INSERT INTO `sys_logininfor` VALUES (798, 't', '192.168.101.121', '内网IP', 'Curl 8.1.2', '', '1', '验证码错误', '2026-11-17 09:05:26');
INSERT INTO `sys_logininfor` VALUES (799, '13900000001', '192.168.101.121', '内网IP', 'Curl 8.1.2', '', '0', '登录成功', '2026-11-17 09:06:59');
INSERT INTO `sys_logininfor` VALUES (800, '13900000001', '192.168.101.121', '内网IP', 'Projectapp2 1', 'iOS 14.7 beta 2', '0', '登录成功', '2026-11-17 09:08:17');
INSERT INTO `sys_logininfor` VALUES (801, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-17 09:16:23');
INSERT INTO `sys_logininfor` VALUES (802, '13900000001', '192.168.101.121', '内网IP', 'Curl 8.1.2', '', '1', '密码输入错误1次', '2026-11-17 10:51:59');
INSERT INTO `sys_logininfor` VALUES (803, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-17 10:53:04');
INSERT INTO `sys_logininfor` VALUES (804, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-17 14:18:18');
INSERT INTO `sys_logininfor` VALUES (805, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 14:21:58');
INSERT INTO `sys_logininfor` VALUES (806, '18785365694', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '注册成功', '2026-11-17 14:37:03');
INSERT INTO `sys_logininfor` VALUES (807, '18785365695', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '注册成功', '2026-11-17 14:43:50');
INSERT INTO `sys_logininfor` VALUES (808, '18785365694', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 14:44:09');
INSERT INTO `sys_logininfor` VALUES (809, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 14:51:36');
INSERT INTO `sys_logininfor` VALUES (810, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 14:56:01');
INSERT INTO `sys_logininfor` VALUES (811, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '注册成功', '2026-11-17 15:07:01');
INSERT INTO `sys_logininfor` VALUES (812, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:07:22');
INSERT INTO `sys_logininfor` VALUES (813, '13900149001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '注册成功', '2026-11-17 15:09:15');
INSERT INTO `sys_logininfor` VALUES (814, '13900149001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:09:35');
INSERT INTO `sys_logininfor` VALUES (815, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:10:14');
INSERT INTO `sys_logininfor` VALUES (816, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:11:08');
INSERT INTO `sys_logininfor` VALUES (817, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:14:29');
INSERT INTO `sys_logininfor` VALUES (818, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:19:18');
INSERT INTO `sys_logininfor` VALUES (819, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:21:41');
INSERT INTO `sys_logininfor` VALUES (820, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:22:07');
INSERT INTO `sys_logininfor` VALUES (821, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:22:24');
INSERT INTO `sys_logininfor` VALUES (822, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:22:52');
INSERT INTO `sys_logininfor` VALUES (823, '18785365696', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:24:23');
INSERT INTO `sys_logininfor` VALUES (824, '18785365697', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '注册成功', '2026-11-17 15:47:40');
INSERT INTO `sys_logininfor` VALUES (825, '13900139001', '127.0.0.1', '内网IP', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-17 15:51:10');
INSERT INTO `sys_logininfor` VALUES (826, '13900000001', '192.168.101.121', '内网IP', 'Projectapp2 1', 'iOS 14.7 beta 2', '0', '登录成功', '2026-11-17 16:12:47');
INSERT INTO `sys_logininfor` VALUES (827, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-17 16:16:42');
INSERT INTO `sys_logininfor` VALUES (828, '13900139001', '127.0.0.1', '内网IP', 'WeChat 8.0.5', 'iOS 15.0', '0', '登录成功', '2026-11-17 16:55:20');
INSERT INTO `sys_logininfor` VALUES (829, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-17 16:58:41');
INSERT INTO `sys_logininfor` VALUES (830, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-17 17:37:04');
INSERT INTO `sys_logininfor` VALUES (831, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-17 21:09:30');
INSERT INTO `sys_logininfor` VALUES (832, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-17 21:09:35');
INSERT INTO `sys_logininfor` VALUES (833, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-17 21:09:35');
INSERT INTO `sys_logininfor` VALUES (834, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-17 21:09:43');
INSERT INTO `sys_logininfor` VALUES (835, 'admin', '154.83.128.126', 'XX XX', 'Chrome 131', 'Windows >=10', '1', '验证码错误', '2026-11-18 01:37:42');
INSERT INTO `sys_logininfor` VALUES (836, 'admin', '154.83.128.126', 'XX XX', 'Chrome 131', 'Windows >=10', '1', '验证码错误', '2026-11-18 01:37:43');
INSERT INTO `sys_logininfor` VALUES (837, 'admin', '154.83.128.126', 'XX XX', 'Chrome 131', 'Windows >=10', '1', '验证码错误', '2026-11-18 01:43:38');
INSERT INTO `sys_logininfor` VALUES (838, 'admin', '154.83.128.126', 'XX XX', 'Chrome 131', 'Windows >=10', '1', '验证码错误', '2026-11-18 01:43:39');
INSERT INTO `sys_logininfor` VALUES (839, 'admin', '154.83.128.126', 'XX XX', 'Chrome 131', 'Windows >=10', '1', '验证码错误', '2026-11-18 01:43:40');
INSERT INTO `sys_logininfor` VALUES (840, 'admin', '154.83.128.126', 'XX XX', 'Chrome 131', 'Windows >=10', '1', '验证码错误', '2026-11-18 01:43:41');
INSERT INTO `sys_logininfor` VALUES (841, 'admin', '154.83.128.126', 'XX XX', 'Chrome 131.0', 'Windows >=10', '1', '验证码错误', '2026-11-18 05:45:20');
INSERT INTO `sys_logininfor` VALUES (842, 'admin', '154.83.128.126', 'XX XX', 'Chrome 131.0', 'Windows >=10', '1', '验证码错误', '2026-11-18 05:45:21');
INSERT INTO `sys_logininfor` VALUES (843, 'admin', '112.65.60.15', 'XX XX', 'Curl 8.7.1', '', '1', '验证码错误', '2026-11-18 10:07:58');
INSERT INTO `sys_logininfor` VALUES (844, 'admin', '112.65.60.15', 'XX XX', 'Curl 8.7.1', '', '1', '验证码错误', '2026-11-18 10:07:58');
INSERT INTO `sys_logininfor` VALUES (845, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-18 10:24:29');
INSERT INTO `sys_logininfor` VALUES (846, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '0', '登录成功', '2026-11-18 10:24:42');
INSERT INTO `sys_logininfor` VALUES (847, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-18 10:49:54');
INSERT INTO `sys_logininfor` VALUES (848, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-18 10:52:54');
INSERT INTO `sys_logininfor` VALUES (849, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-18 10:54:47');
INSERT INTO `sys_logininfor` VALUES (850, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '1', '密码输入错误1次', '2026-11-18 11:10:21');
INSERT INTO `sys_logininfor` VALUES (851, 'admin', '58.16.41.98', 'XX XX', 'Edge 142', 'Windows >=10', '0', '登录成功', '2026-11-18 11:10:30');
INSERT INTO `sys_logininfor` VALUES (852, '13900000009', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-18 11:13:56');
INSERT INTO `sys_logininfor` VALUES (853, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-18 11:13:58');
INSERT INTO `sys_logininfor` VALUES (854, '13900000009', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-18 11:14:50');
INSERT INTO `sys_logininfor` VALUES (855, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-18 11:14:51');
INSERT INTO `sys_logininfor` VALUES (856, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-18 11:15:57');
INSERT INTO `sys_logininfor` VALUES (857, '18800001111', '58.16.41.98', 'XX XX', 'Curl 8.16.0', '', '0', '登录成功', '2026-11-18 11:37:20');
INSERT INTO `sys_logininfor` VALUES (858, 'admin', '54.169.49.130', 'XX XX', 'Chrome 157', 'Windows10', '1', '验证码错误', '2026-11-18 11:44:06');
INSERT INTO `sys_logininfor` VALUES (859, 'admin', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-18 11:48:15');
INSERT INTO `sys_logininfor` VALUES (860, '13900000009', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-18 11:48:17');
INSERT INTO `sys_logininfor` VALUES (861, '13900000009', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-18 11:48:29');
INSERT INTO `sys_logininfor` VALUES (862, 'admin', '54.169.49.130', 'XX XX', 'Chrome 157', 'Windows10', '0', '登录成功', '2026-11-18 11:50:33');
INSERT INTO `sys_logininfor` VALUES (863, '13900000001', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '1', '密码输入错误1次', '2026-11-18 14:10:45');
INSERT INTO `sys_logininfor` VALUES (864, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-18 14:11:04');
INSERT INTO `sys_logininfor` VALUES (865, 'admin', '58.16.41.98', 'XX XX', 'Chrome 157', 'Windows10', '0', '登录成功', '2026-11-18 14:24:24');
INSERT INTO `sys_logininfor` VALUES (866, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '1', '密码输入错误1次', '2026-11-18 14:49:54');
INSERT INTO `sys_logininfor` VALUES (867, '13911112222', '127.0.0.1', '内网IP', 'Curl 8.7.1', '', '1', '密码输入错误2次', '2026-11-18 14:50:36');
INSERT INTO `sys_logininfor` VALUES (868, '13900139001', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-11-18 15:17:47');
INSERT INTO `sys_logininfor` VALUES (869, '13900139001', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-11-18 15:17:56');
INSERT INTO `sys_logininfor` VALUES (870, '13900139001', '127.0.0.1', '内网IP', 'Python-urllib 3.13', '', '0', '登录成功', '2026-11-18 15:18:06');
INSERT INTO `sys_logininfor` VALUES (871, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-18 15:35:55');
INSERT INTO `sys_logininfor` VALUES (872, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-18 15:53:24');
INSERT INTO `sys_logininfor` VALUES (873, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-18 15:53:42');
INSERT INTO `sys_logininfor` VALUES (874, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-18 15:54:00');
INSERT INTO `sys_logininfor` VALUES (875, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-18 15:54:16');
INSERT INTO `sys_logininfor` VALUES (876, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-18 15:55:06');
INSERT INTO `sys_logininfor` VALUES (877, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-18 15:55:20');
INSERT INTO `sys_logininfor` VALUES (878, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-18 15:55:32');
INSERT INTO `sys_logininfor` VALUES (879, '13900139001', '220.197.4.230', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-18 15:59:35');
INSERT INTO `sys_logininfor` VALUES (880, '13638010667', '114.138.157.27', 'XX XX', 'Okhttp 4.12.0', '', '0', '注册成功', '2026-11-18 16:09:03');
INSERT INTO `sys_logininfor` VALUES (881, '13638010667', '114.138.157.27', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-18 16:09:37');
INSERT INTO `sys_logininfor` VALUES (882, '13900139001', '114.139.112.68', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-18 16:14:16');
INSERT INTO `sys_logininfor` VALUES (883, '13900139001', '127.0.0.1', '内网IP', 'PowerShell 7.6.4', 'Windows 10.0', '0', '登录成功', '2026-11-18 16:19:18');
INSERT INTO `sys_logininfor` VALUES (884, '13900139001', '114.139.112.68', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-18 16:21:00');
INSERT INTO `sys_logininfor` VALUES (885, '13900000001', '39.144.231.36', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-18 16:22:18');
INSERT INTO `sys_logininfor` VALUES (886, '13339620617', '39.144.231.76', 'XX XX', 'Okhttp 4.12.0', '', '0', '注册成功', '2026-11-18 16:22:34');
INSERT INTO `sys_logininfor` VALUES (887, '15585102712', '220.197.21.177', 'XX XX', 'Okhttp 4.12.0', '', '0', '注册成功', '2026-11-18 16:24:49');
INSERT INTO `sys_logininfor` VALUES (888, '13900000001', '39.144.231.36', 'XX XX', 'Okhttp 4.12.0', '', '0', '登录成功', '2026-11-18 16:27:17');
INSERT INTO `sys_logininfor` VALUES (889, '13900139001', '127.0.0.1', '内网IP', 'Curl 8.21.0', '', '0', '登录成功', '2026-11-18 16:39:55');
INSERT INTO `sys_logininfor` VALUES (890, 'admin', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', '0', '登录成功', '2026-11-19 09:21:51');
INSERT INTO `sys_logininfor` VALUES (891, 'admin', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', '0', '登录成功', '2026-11-19 09:23:28');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '#' COMMENT '请求地址',
  `target` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '打开方式（menuItem页签 menuBlank新窗口）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `is_refresh` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '是否刷新（0刷新 1不刷新）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2133 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, '#', '', 'M', '0', '1', '', 'fa fa-gear', 'admin', '2026-10-13 09:00:51', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, '#', '', 'M', '0', '1', '', 'fa fa-video-camera', 'admin', '2026-10-13 09:00:51', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, '#', '', 'M', '0', '1', '', 'fa fa-bars', 'admin', '2026-10-13 09:00:51', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', 'menuBlank', 'C', '0', '1', '', 'fa fa-location-arrow', 'admin', '2026-10-13 09:00:51', '', NULL, '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, '/system/user', '', 'C', '0', '1', 'system:user:view', 'fa fa-user-o', 'admin', '2026-10-13 09:00:51', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, '/system/role', '', 'C', '0', '1', 'system:role:view', 'fa fa-user-secret', 'admin', '2026-10-13 09:00:51', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, '/system/menu', '', 'C', '0', '1', 'system:menu:view', 'fa fa-th-list', 'admin', '2026-10-13 09:00:51', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, '/system/dept', '', 'C', '0', '1', 'system:dept:view', 'fa fa-outdent', 'admin', '2026-10-13 09:00:51', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, '/system/post', '', 'C', '0', '1', 'system:post:view', 'fa fa-address-card-o', 'admin', '2026-10-13 09:00:51', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, '/system/dict', '', 'C', '0', '1', 'system:dict:view', 'fa fa-bookmark-o', 'admin', '2026-10-13 09:00:51', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, '/system/config', '', 'C', '0', '1', 'system:config:view', 'fa fa-sun-o', 'admin', '2026-10-13 09:00:51', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, '/system/notice', '', 'C', '0', '1', 'system:notice:view', 'fa fa-bullhorn', 'admin', '2026-10-13 09:00:51', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, '#', '', 'M', '0', '1', '', 'fa fa-pencil-square-o', 'admin', '2026-10-13 09:00:51', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, '/monitor/online', '', 'C', '0', '1', 'monitor:online:view', 'fa fa-user-circle', 'admin', '2026-10-13 09:00:51', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, '/monitor/job', '', 'C', '0', '1', 'monitor:job:view', 'fa fa-tasks', 'admin', '2026-10-13 09:00:51', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, '/monitor/data', '', 'C', '0', '1', 'monitor:data:view', 'fa fa-bug', 'admin', '2026-10-13 09:00:51', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, '/monitor/server', '', 'C', '0', '1', 'monitor:server:view', 'fa fa-server', 'admin', '2026-10-13 09:00:51', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, '/monitor/cache', '', 'C', '0', '1', 'monitor:cache:view', 'fa fa-cube', 'admin', '2026-10-13 09:00:51', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '表单构建', 3, 1, '/tool/build', '', 'C', '0', '1', 'tool:build:view', 'fa fa-wpforms', 'admin', '2026-10-13 09:00:51', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (115, '代码生成', 3, 2, '/tool/gen', '', 'C', '0', '1', 'tool:gen:view', 'fa fa-code', 'admin', '2026-10-13 09:00:51', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (116, '系统接口', 3, 3, '/tool/swagger', '', 'C', '0', '1', 'tool:swagger:view', 'fa fa-gg', 'admin', '2026-10-13 09:00:51', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, '/monitor/operlog', '', 'C', '0', '1', 'monitor:operlog:view', 'fa fa-address-book', 'admin', '2026-10-13 09:00:51', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, '/monitor/logininfor', '', 'C', '0', '1', 'monitor:logininfor:view', 'fa fa-file-image-o', 'admin', '2026-10-13 09:00:51', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '#', '', 'F', '0', '1', 'system:user:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '#', '', 'F', '0', '1', 'system:user:add', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '#', '', 'F', '0', '1', 'system:user:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '#', '', 'F', '0', '1', 'system:user:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '#', '', 'F', '0', '1', 'system:user:export', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '#', '', 'F', '0', '1', 'system:user:import', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '#', '', 'F', '0', '1', 'system:user:resetPwd', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '#', '', 'F', '0', '1', 'system:role:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '#', '', 'F', '0', '1', 'system:role:add', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '#', '', 'F', '0', '1', 'system:role:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '#', '', 'F', '0', '1', 'system:role:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '#', '', 'F', '0', '1', 'system:role:export', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '#', '', 'F', '0', '1', 'system:menu:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '#', '', 'F', '0', '1', 'system:menu:add', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '#', '', 'F', '0', '1', 'system:menu:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '#', '', 'F', '0', '1', 'system:menu:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '#', '', 'F', '0', '1', 'system:dept:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '#', '', 'F', '0', '1', 'system:dept:add', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '#', '', 'F', '0', '1', 'system:dept:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '#', '', 'F', '0', '1', 'system:dept:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '#', '', 'F', '0', '1', 'system:post:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '#', '', 'F', '0', '1', 'system:post:add', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '#', '', 'F', '0', '1', 'system:post:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '#', '', 'F', '0', '1', 'system:post:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '#', '', 'F', '0', '1', 'system:post:export', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', 'F', '0', '1', 'system:dict:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', 'F', '0', '1', 'system:dict:add', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', 'F', '0', '1', 'system:dict:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', 'F', '0', '1', 'system:dict:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', 'F', '0', '1', 'system:dict:export', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', 'F', '0', '1', 'system:config:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', 'F', '0', '1', 'system:config:add', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', 'F', '0', '1', 'system:config:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', 'F', '0', '1', 'system:config:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', 'F', '0', '1', 'system:config:export', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', 'F', '0', '1', 'system:notice:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', 'F', '0', '1', 'system:notice:add', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', 'F', '0', '1', 'system:notice:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', 'F', '0', '1', 'system:notice:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', 'F', '0', '1', 'monitor:operlog:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', 'F', '0', '1', 'monitor:operlog:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '详细信息', 500, 3, '#', '', 'F', '0', '1', 'monitor:operlog:detail', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '日志导出', 500, 4, '#', '', 'F', '0', '1', 'monitor:operlog:export', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录查询', 501, 1, '#', '', 'F', '0', '1', 'monitor:logininfor:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '登录删除', 501, 2, '#', '', 'F', '0', '1', 'monitor:logininfor:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '日志导出', 501, 3, '#', '', 'F', '0', '1', 'monitor:logininfor:export', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '账户解锁', 501, 4, '#', '', 'F', '0', '1', 'monitor:logininfor:unlock', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '在线查询', 109, 1, '#', '', 'F', '0', '1', 'monitor:online:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '批量强退', 109, 2, '#', '', 'F', '0', '1', 'monitor:online:batchForceLogout', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '单条强退', 109, 3, '#', '', 'F', '0', '1', 'monitor:online:forceLogout', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务查询', 110, 1, '#', '', 'F', '0', '1', 'monitor:job:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务新增', 110, 2, '#', '', 'F', '0', '1', 'monitor:job:add', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务修改', 110, 3, '#', '', 'F', '0', '1', 'monitor:job:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '任务删除', 110, 4, '#', '', 'F', '0', '1', 'monitor:job:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '状态修改', 110, 5, '#', '', 'F', '0', '1', 'monitor:job:changeStatus', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '任务详细', 110, 6, '#', '', 'F', '0', '1', 'monitor:job:detail', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '任务导出', 110, 7, '#', '', 'F', '0', '1', 'monitor:job:export', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成查询', 115, 1, '#', '', 'F', '0', '1', 'tool:gen:list', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '生成修改', 115, 2, '#', '', 'F', '0', '1', 'tool:gen:edit', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '生成删除', 115, 3, '#', '', 'F', '0', '1', 'tool:gen:remove', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '预览代码', 115, 4, '#', '', 'F', '0', '1', 'tool:gen:preview', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1061, '生成代码', 115, 5, '#', '', 'F', '0', '1', 'tool:gen:code', '#', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '社区类别新增', 2028, 1, '#', 'menuItem', 'F', '0', '1', 'community:category:add', '#', 'admin', '2026-10-13 11:25:48', '', NULL, '类别接口权限（无菜单）');
INSERT INTO `sys_menu` VALUES (2019, '课程类别新增', 2027, 1, '#', 'menuItem', 'F', '0', '1', 'course:category:add', '#', 'admin', '2026-10-13 11:25:48', '', NULL, '类别接口权限（无菜单）');
INSERT INTO `sys_menu` VALUES (2020, '社区类别修改', 2028, 2, '#', 'menuItem', 'F', '0', '1', 'community:category:edit', '#', 'admin', '2026-10-13 11:25:48', '', NULL, '类别接口权限（无菜单）');
INSERT INTO `sys_menu` VALUES (2021, '课程类别修改', 2027, 2, '#', 'menuItem', 'F', '0', '1', 'course:category:edit', '#', 'admin', '2026-10-13 11:25:48', '', NULL, '类别接口权限（无菜单）');
INSERT INTO `sys_menu` VALUES (2022, '社区类别删除', 2028, 3, '#', 'menuItem', 'F', '0', '1', 'community:category:remove', '#', 'admin', '2026-10-13 11:25:48', '', NULL, '类别接口权限（无菜单）');
INSERT INTO `sys_menu` VALUES (2023, '课程类别删除', 2027, 3, '#', 'menuItem', 'F', '0', '1', 'course:category:remove', '#', 'admin', '2026-10-13 11:25:48', '', NULL, '类别接口权限（无菜单）');
INSERT INTO `sys_menu` VALUES (2024, '社区类别导出', 2028, 4, '#', 'menuItem', 'F', '0', '1', 'community:category:export', '#', 'admin', '2026-10-13 11:25:48', '', NULL, '类别接口权限（无菜单）');
INSERT INTO `sys_menu` VALUES (2025, '课程类别导出', 2027, 4, '#', 'menuItem', 'F', '0', '1', 'course:category:export', '#', 'admin', '2026-10-13 11:25:48', '', NULL, '类别接口权限（无菜单）');
INSERT INTO `sys_menu` VALUES (2026, '学习管理', 0, 5, '#', 'menuItem', 'M', '0', '1', '', 'fa fa-graduation-cap', 'admin', '2026-10-13 14:25:49', '', NULL, '学习平台管理目录');
INSERT INTO `sys_menu` VALUES (2027, '课程类别', 2026, 1, '/course/category', 'menuItem', 'C', '0', '1', 'course:category:view', '#', 'admin', '2026-10-13 14:25:50', '', NULL, '课程模块类别菜单');
INSERT INTO `sys_menu` VALUES (2028, '社区类别', 2026, 2, '/community/category', 'menuItem', 'C', '0', '1', 'community:category:view', '#', 'admin', '2026-10-13 14:25:50', '', NULL, '社区文章模块类别菜单');
INSERT INTO `sys_menu` VALUES (2029, '社区类别查询', 2028, 1, '#', 'menuItem', 'F', '0', '1', 'community:category:list', '#', 'admin', '2026-10-13 14:25:50', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '课程类别查询', 2027, 1, '#', 'menuItem', 'F', '0', '1', 'course:category:list', '#', 'admin', '2026-10-13 14:25:50', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '课程管理', 2026, 3, '/course/course', 'menuItem', 'C', '0', '1', 'course:course:view', '#', 'admin', '2026-10-13 15:35:29', '', NULL, '课程模块菜单');
INSERT INTO `sys_menu` VALUES (2033, '课程管理查询', 2032, 1, '#', 'menuItem', 'F', '0', '1', 'course:course:list', '#', 'admin', '2026-10-13 15:35:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '课程管理新增', 2032, 2, '#', 'menuItem', 'F', '0', '1', 'course:course:add', '#', 'admin', '2026-10-13 15:35:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '课程管理修改', 2032, 3, '#', 'menuItem', 'F', '0', '1', 'course:course:edit', '#', 'admin', '2026-10-13 15:35:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '课程管理删除', 2032, 4, '#', 'menuItem', 'F', '0', '1', 'course:course:remove', '#', 'admin', '2026-10-13 15:35:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, '课程管理导出', 2032, 5, '#', 'menuItem', 'F', '0', '1', 'course:course:export', '#', 'admin', '2026-10-13 15:35:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '社区帖子', 2026, 4, '/community/post', 'menuItem', 'C', '0', '1', 'community:post:view', '#', 'admin', '2026-10-13 17:26:05', '', NULL, '社区模块帖子菜单');
INSERT INTO `sys_menu` VALUES (2041, '社区帖子新增', 2040, 1, '#', 'menuItem', 'F', '0', '1', 'community:post:add', '#', 'admin', '2026-10-13 17:26:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '社区帖子修改', 2040, 2, '#', 'menuItem', 'F', '0', '1', 'community:post:edit', '#', 'admin', '2026-10-13 17:26:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2043, '社区帖子删除', 2040, 3, '#', 'menuItem', 'F', '0', '1', 'community:post:remove', '#', 'admin', '2026-10-13 17:26:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '社区帖子导出', 2040, 4, '#', 'menuItem', 'F', '0', '1', 'community:post:export', '#', 'admin', '2026-10-13 17:26:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '短视频管理', 2026, 5, '/video/shortvideo', 'menuItem', 'C', '0', '1', 'video:shortvideo:view', 'fa fa-video-camera', 'admin', '2026-10-14 11:35:59', '', NULL, '短视频模块菜单');
INSERT INTO `sys_menu` VALUES (2049, '短视频管理查询', 2048, 1, '#', 'menuItem', 'F', '0', '1', 'video:shortvideo:list', '#', 'admin', '2026-10-14 11:35:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '短视频管理新增', 2048, 2, '#', 'menuItem', 'F', '0', '1', 'video:shortvideo:add', '#', 'admin', '2026-10-14 11:35:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '短视频管理修改', 2048, 3, '#', 'menuItem', 'F', '0', '1', 'video:shortvideo:edit', '#', 'admin', '2026-10-14 11:35:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '短视频管理删除', 2048, 4, '#', 'menuItem', 'F', '0', '1', 'video:shortvideo:remove', '#', 'admin', '2026-10-14 11:35:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '短视频管理导出', 2048, 5, '#', 'menuItem', 'F', '0', '1', 'video:shortvideo:export', '#', 'admin', '2026-10-14 11:35:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '帖子审核', 2026, 6, '/community/post/audit', 'menuItem', 'C', '0', '1', 'community:post:audit', '#', 'admin', '2026-10-15 15:02:32', '', NULL, '社区帖子审核菜单');
INSERT INTO `sys_menu` VALUES (2057, '轮播图管理', 2026, 7, '/course/banner', 'menuItem', 'C', '0', '1', 'course:banner:view', 'fa fa-picture-o', 'admin', '2026-10-15 17:46:59', '', NULL, '课程模块轮播图菜单');
INSERT INTO `sys_menu` VALUES (2058, '轮播图管理新增', 2057, 1, '#', 'menuItem', 'F', '0', '1', 'course:banner:add', '#', 'admin', '2026-10-15 17:46:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2059, '轮播图管理修改', 2057, 2, '#', 'menuItem', 'F', '0', '1', 'course:banner:edit', '#', 'admin', '2026-10-15 17:46:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '轮播图管理删除', 2057, 3, '#', 'menuItem', 'F', '0', '1', 'course:banner:remove', '#', 'admin', '2026-10-15 17:46:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2061, '轮播图管理导出', 2057, 4, '#', 'menuItem', 'F', '0', '1', 'course:banner:export', '#', 'admin', '2026-10-15 17:46:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2069, '话题管理', 2026, 8, '/community/topic', 'menuItem', 'C', '0', '1', 'community:topic:view', 'fa fa-tags', 'admin', '2026-11-02 16:16:41', '', NULL, '话题管理菜单');
INSERT INTO `sys_menu` VALUES (2070, '话题列表', 2069, 1, '#', 'menuItem', 'F', '0', '1', 'community:topic:list', '#', 'admin', '2026-11-02 16:16:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2071, '话题新增', 2069, 2, '#', 'menuItem', 'F', '0', '1', 'community:topic:add', '#', 'admin', '2026-11-02 16:16:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '话题修改', 2069, 3, '#', 'menuItem', 'F', '0', '1', 'community:topic:edit', '#', 'admin', '2026-11-02 16:16:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2073, '话题删除', 2069, 4, '#', 'menuItem', 'F', '0', '1', 'community:topic:remove', '#', 'admin', '2026-11-02 16:16:41', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2084, '积分列表', 2088, 1, '#', 'menuItem', 'F', '0', '1', 'user:points:list', '#', 'admin', '2026-11-02 16:27:24', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2088, '积分记录', 2026, 9, '/user/points/records', 'menuItem', 'C', '0', '1', 'user:points:view', 'fa fa-diamond', 'admin', '2026-11-10 10:07:16', '', NULL, '积分记录（按用户查看积分来源与明细）');
INSERT INTO `sys_menu` VALUES (2100, '积分商城', 0, 6, '#', 'menuItem', 'M', '0', '1', '', 'fa fa-shopping-bag', 'admin', '2026-11-17 15:37:48', '', NULL, '积分商城管理目录');
INSERT INTO `sys_menu` VALUES (2101, '商品分类', 2100, 1, '/shop/category', 'menuItem', 'C', '0', '1', 'shop:category:view', 'fa fa-tags', 'admin', '2026-11-17 15:37:50', '', NULL, '积分商城商品分类');
INSERT INTO `sys_menu` VALUES (2102, '商品管理', 2100, 2, '/shop/product', 'menuItem', 'C', '0', '1', 'shop:product:view', 'fa fa-gift', 'admin', '2026-11-17 15:37:51', '', NULL, '积分商城商品管理');
INSERT INTO `sys_menu` VALUES (2103, '兑换记录', 2100, 3, '/shop/order', 'menuItem', 'C', '0', '1', 'shop:order:view', 'fa fa-ticket', 'admin', '2026-11-17 15:37:51', '', NULL, '积分商城兑换记录（只读）');
INSERT INTO `sys_menu` VALUES (2104, '兑换记录查询', 2103, 1, '#', 'menuItem', 'F', '0', '1', 'shop:order:list', '#', 'admin', '2026-11-17 15:37:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2105, '商品管理查询', 2102, 1, '#', 'menuItem', 'F', '0', '1', 'shop:product:list', '#', 'admin', '2026-11-17 15:37:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2106, '商品分类查询', 2101, 1, '#', 'menuItem', 'F', '0', '1', 'shop:category:list', '#', 'admin', '2026-11-17 15:37:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2107, '商品管理新增', 2102, 2, '#', 'menuItem', 'F', '0', '1', 'shop:product:add', '#', 'admin', '2026-11-17 15:37:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2108, '商品分类新增', 2101, 2, '#', 'menuItem', 'F', '0', '1', 'shop:category:add', '#', 'admin', '2026-11-17 15:37:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2109, '商品管理修改', 2102, 3, '#', 'menuItem', 'F', '0', '1', 'shop:product:edit', '#', 'admin', '2026-11-17 15:37:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '商品分类修改', 2101, 3, '#', 'menuItem', 'F', '0', '1', 'shop:category:edit', '#', 'admin', '2026-11-17 15:37:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2111, '商品管理删除', 2102, 4, '#', 'menuItem', 'F', '0', '1', 'shop:product:remove', '#', 'admin', '2026-11-17 15:37:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2112, '商品分类删除', 2101, 4, '#', 'menuItem', 'F', '0', '1', 'shop:category:remove', '#', 'admin', '2026-11-17 15:37:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2119, '协议管理', 2026, 10, '/user/agreement', 'menuItem', 'C', '0', '1', 'user:agreement:view', 'fa fa-file-text-o', 'admin', '2026-11-17 16:14:33', '', NULL, '用户协议/隐私政策/关于我们');
INSERT INTO `sys_menu` VALUES (2120, '协议新增', 2119, 1, '#', 'menuItem', 'F', '0', '1', 'user:agreement:add', '#', 'admin', '2026-11-17 16:14:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2121, '协议修改', 2119, 2, '#', 'menuItem', 'F', '0', '1', 'user:agreement:edit', '#', 'admin', '2026-11-17 16:14:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2122, '协议删除', 2119, 3, '#', 'menuItem', 'F', '0', '1', 'user:agreement:remove', '#', 'admin', '2026-11-17 16:14:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2128, '违禁词管理', 2026, 11, '/community/sensitive-word', 'menuItem', 'C', '0', '1', 'community:sensitive:view', 'fa fa-ban', 'admin', '2026-11-19 09:18:51', '', NULL, '帖子违禁词拦截词库');
INSERT INTO `sys_menu` VALUES (2129, '违禁词查询', 2128, 1, '#', 'menuItem', 'F', '0', '1', 'community:sensitive:list', '#', 'admin', '2026-11-19 09:18:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2130, '违禁词新增', 2128, 2, '#', 'menuItem', 'F', '0', '1', 'community:sensitive:add', '#', 'admin', '2026-11-19 09:18:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2131, '违禁词修改', 2128, 3, '#', 'menuItem', 'F', '0', '1', 'community:sensitive:edit', '#', 'admin', '2026-11-19 09:18:51', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2132, '违禁词删除', 2128, 4, '#', 'menuItem', 'F', '0', '1', 'community:sensitive:remove', '#', 'admin', '2026-11-19 09:18:51', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-10-13 09:00:52', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-10-13 09:00:52', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (3, '若依开源框架介绍', '1', 0x3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE9A1B9E79BAEE4BB8BE7BB8D3C2F7370616E3E3C2F703E3C703E3C666F6E7420636F6C6F723D2223333333333333223E52756F5969E5BC80E6BA90E9A1B9E79BAEE698AFE4B8BAE4BC81E4B89AE794A8E688B7E5AE9AE588B6E79A84E5908EE58FB0E8849AE6898BE69EB6E6A186E69EB6EFBC8CE4B8BAE4BC81E4B89AE68993E980A0E79A84E4B880E7AB99E5BC8FE8A7A3E586B3E696B9E6A188EFBC8CE9998DE4BD8EE4BC81E4B89AE5BC80E58F91E68890E69CACEFBC8CE68F90E58D87E5BC80E58F91E69588E78E87E38082E4B8BBE8A681E58C85E68BACE794A8E688B7E7AEA1E79086E38081E8A792E889B2E7AEA1E79086E38081E983A8E997A8E7AEA1E79086E38081E88F9CE58D95E7AEA1E79086E38081E58F82E695B0E7AEA1E79086E38081E5AD97E585B8E7AEA1E79086E380813C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE5B297E4BD8DE7AEA1E790863C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E5AE9AE697B6E4BBBBE58AA13C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE380813C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE69C8DE58AA1E79B91E68EA7E38081E799BBE5BD95E697A5E5BF97E38081E6938DE4BD9CE697A5E5BF97E38081E4BBA3E7A081E7949FE68890E7AD89E58A9FE883BDE38082E585B6E4B8ADEFBC8CE8BF98E694AFE68C81E5A49AE695B0E68DAEE6BA90E38081E695B0E68DAEE69D83E99990E38081E59BBDE99985E58C96E380815265646973E7BC93E5AD98E38081446F636B6572E983A8E7BDB2E38081E6BB91E58AA8E9AA8CE8AF81E7A081E38081E7ACACE4B889E696B9E8AEA4E8AF81E799BBE5BD95E38081E58886E5B883E5BC8FE4BA8BE58AA1E380813C2F7370616E3E3C666F6E7420636F6C6F723D2223333333333333223EE58886E5B883E5BC8FE69687E4BBB6E5AD98E582A83C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E58886E5BA93E58886E8A1A8E5A484E79086E7AD89E68A80E69CAFE789B9E782B9E380823C2F7370616E3E3C2F703E3C703E3C696D67207372633D2268747470733A2F2F666F727564612E67697465652E636F6D2F696D616765732F313730353033303538333937373430313635312F35656435646236615F313135313030342E706E6722207374796C653D2277696474683A20363470783B223E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE5AE98E7BD91E58F8AE6BC94E7A4BA3C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE5AE98E7BD91E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F72756F79692E7669703C2F613E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E3C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE69687E6A1A3E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F646F632E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F646F632E72756F79692E7669703C2F613E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E4B88DE58886E7A6BBE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F64656D6F2E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F64656D6F2E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E58886E7A6BBE78988E69CACE38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F7675652E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F7675652E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E5BEAEE69C8DE58AA1E78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F636C6F75642E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F636C6F75642E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E7A7BBE58AA8E7ABAFE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F68352E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F68352E72756F79692E7669703C2F613E3C2F703E3C703E3C6272207374796C653D22636F6C6F723A207267622834382C2034392C203531293B20666F6E742D66616D696C793A202671756F743B48656C766574696361204E6575652671756F743B2C2048656C7665746963612C20417269616C2C2073616E732D73657269663B20666F6E742D73697A653A20313270783B223E3C2F703E, '0', 'admin', '2026-10-13 09:00:52', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id` ASC, `notice_id` ASC) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告已读记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 370 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"java\"],\"categoryType\":[\"course\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', '{\"msg\":\"新增类别\'java\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 10:46:38', 95);
INSERT INTO `sys_oper_log` VALUES (101, '社区类别', 1, 'com.ruoyi.web.controller.community.CommunityCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/community/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"java\"],\"categoryType\":[\"article\"],\"orderNum\":[\"99\"],\"status\":[\"0\"]}', '{\"msg\":\"新增类别\'java\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 10:46:38', 51);
INSERT INTO `sys_oper_log` VALUES (102, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"测试类别\"],\"categoryType\":[\"course\"],\"orderNum\":[\"9\"],\"status\":[\"0\"],\"remark\":[\"e2e\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:46:52', 218);
INSERT INTO `sys_oper_log` VALUES (103, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"java\"],\"categoryType\":[\"course\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', '{\"msg\":\"新增类别\'java\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 10:46:52', 48);
INSERT INTO `sys_oper_log` VALUES (104, '社区类别', 1, 'com.ruoyi.web.controller.community.CommunityCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/community/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"测试类别\"],\"categoryType\":[\"article\"],\"orderNum\":[\"9\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:46:52', 136);
INSERT INTO `sys_oper_log` VALUES (105, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"  mysql  \"],\"categoryType\":[\"course\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:46:53', 342);
INSERT INTO `sys_oper_log` VALUES (106, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"无序类别\"],\"categoryType\":[\"course\"],\"orderNum\":[\"\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:46:53', 159);
INSERT INTO `sys_oper_log` VALUES (107, '课程类别', 2, 'com.ruoyi.web.controller.course.CourseCategoryController.editSave()', 'POST', 1, '13900000001', NULL, '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"115\"],\"categoryName\":[\"测试类别改\"],\"categoryType\":[\"course\"],\"orderNum\":[\"88\"],\"status\":[\"1\"],\"remark\":[\"edited\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:46:55', 226);
INSERT INTO `sys_oper_log` VALUES (108, '课程类别', 2, 'com.ruoyi.web.controller.course.CourseCategoryController.editSave()', 'POST', 1, '13900000001', NULL, '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"115\"],\"categoryName\":[\"java\"],\"categoryType\":[\"course\"],\"orderNum\":[\"88\"],\"status\":[\"1\"]}', '{\"msg\":\"修改类别\'java\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 10:46:56', 63);
INSERT INTO `sys_oper_log` VALUES (109, '课程类别', 2, 'com.ruoyi.web.controller.course.CourseCategoryController.editSave()', 'POST', 1, '13900000001', NULL, '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"115\"],\"categoryName\":[\"测试类别改\"],\"categoryType\":[\"article\"],\"orderNum\":[\"88\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:46:56', 234);
INSERT INTO `sys_oper_log` VALUES (110, '课程类别', 2, 'com.ruoyi.web.controller.course.CourseCategoryController.editSave()', 'POST', 1, '13900000001', NULL, '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"999999\"],\"categoryName\":[\"ghost\"],\"categoryType\":[\"course\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', NULL, 1, '类别不存在或已被删除', '2026-10-13 10:46:56', 115);
INSERT INTO `sys_oper_log` VALUES (111, '课程类别', 3, 'com.ruoyi.web.controller.course.CourseCategoryController.remove()', 'POST', 1, '13900000001', NULL, '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"100\"]}', NULL, 1, '类别[java]不属于当前模块，不能删除', '2026-10-13 10:46:57', 51);
INSERT INTO `sys_oper_log` VALUES (112, '课程类别', 3, 'com.ruoyi.web.controller.course.CourseCategoryController.remove()', 'POST', 1, '13900000001', NULL, '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"\"]}', NULL, 1, '未选择要删除的类别数据', '2026-10-13 10:46:57', 1);
INSERT INTO `sys_oper_log` VALUES (113, '课程类别', 3, 'com.ruoyi.web.controller.course.CourseCategoryController.remove()', 'POST', 1, '13900000001', NULL, '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"999999\"]}', NULL, 1, '类别ID[999999]不存在或已被删除', '2026-10-13 10:46:57', 81);
INSERT INTO `sys_oper_log` VALUES (114, '课程类别', 3, 'com.ruoyi.web.controller.course.CourseCategoryController.remove()', 'POST', 1, '13900000001', NULL, '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"115\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:46:58', 213);
INSERT INTO `sys_oper_log` VALUES (115, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"测试类别改\"],\"categoryType\":[\"course\"],\"orderNum\":[\"7\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:46:58', 166);
INSERT INTO `sys_oper_log` VALUES (116, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"测试类别\"],\"categoryType\":[\"course\"],\"orderNum\":[\"9\"],\"status\":[\"0\"],\"remark\":[\"e2e\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:48:31', 332);
INSERT INTO `sys_oper_log` VALUES (117, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"java\"],\"categoryType\":[\"course\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', '{\"msg\":\"新增类别\'java\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 10:48:31', 56);
INSERT INTO `sys_oper_log` VALUES (118, '社区类别', 1, 'com.ruoyi.web.controller.community.CommunityCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/community/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"测试类别\"],\"categoryType\":[\"article\"],\"orderNum\":[\"9\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:48:31', 145);
INSERT INTO `sys_oper_log` VALUES (119, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"  mysql  \"],\"categoryType\":[\"course\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', '{\"msg\":\"新增类别\'mysql\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 10:48:31', 60);
INSERT INTO `sys_oper_log` VALUES (120, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"无序类别\"],\"categoryType\":[\"course\"],\"orderNum\":[\"\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:48:32', 144);
INSERT INTO `sys_oper_log` VALUES (121, '课程类别', 2, 'com.ruoyi.web.controller.course.CourseCategoryController.editSave()', 'POST', 1, '13900000001', NULL, '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"120\"],\"categoryName\":[\"测试类别改\"],\"categoryType\":[\"course\"],\"orderNum\":[\"88\"],\"status\":[\"1\"],\"remark\":[\"edited\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:48:33', 202);
INSERT INTO `sys_oper_log` VALUES (122, '课程类别', 2, 'com.ruoyi.web.controller.course.CourseCategoryController.editSave()', 'POST', 1, '13900000001', NULL, '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"120\"],\"categoryName\":[\"java\"],\"categoryType\":[\"course\"],\"orderNum\":[\"88\"],\"status\":[\"1\"]}', '{\"msg\":\"修改类别\'java\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 10:48:33', 56);
INSERT INTO `sys_oper_log` VALUES (123, '课程类别', 2, 'com.ruoyi.web.controller.course.CourseCategoryController.editSave()', 'POST', 1, '13900000001', NULL, '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"120\"],\"categoryName\":[\"测试类别改\"],\"categoryType\":[\"course\"],\"orderNum\":[\"88\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:48:33', 166);
INSERT INTO `sys_oper_log` VALUES (124, '课程类别', 2, 'com.ruoyi.web.controller.course.CourseCategoryController.editSave()', 'POST', 1, '13900000001', NULL, '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"999999\"],\"categoryName\":[\"ghost\"],\"categoryType\":[\"course\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', NULL, 1, '类别不存在或已被删除', '2026-10-13 10:48:33', 98);
INSERT INTO `sys_oper_log` VALUES (125, '课程类别', 2, 'com.ruoyi.web.controller.course.CourseCategoryController.editSave()', 'POST', 1, '13900000001', NULL, '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"120\"],\"categoryName\":[\"悄悄搬家\"],\"categoryType\":[\"article\"],\"orderNum\":[\"88\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:48:34', 165);
INSERT INTO `sys_oper_log` VALUES (126, '课程类别', 3, 'com.ruoyi.web.controller.course.CourseCategoryController.remove()', 'POST', 1, '13900000001', NULL, '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"121\"]}', NULL, 1, '类别[测试类别]不属于当前模块，不能删除', '2026-10-13 10:48:34', 42);
INSERT INTO `sys_oper_log` VALUES (127, '课程类别', 3, 'com.ruoyi.web.controller.course.CourseCategoryController.remove()', 'POST', 1, '13900000001', NULL, '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"\"]}', NULL, 1, '未选择要删除的类别数据', '2026-10-13 10:48:35', 1);
INSERT INTO `sys_oper_log` VALUES (128, '课程类别', 3, 'com.ruoyi.web.controller.course.CourseCategoryController.remove()', 'POST', 1, '13900000001', NULL, '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"999999\"]}', NULL, 1, '类别ID[999999]不存在或已被删除', '2026-10-13 10:48:35', 51);
INSERT INTO `sys_oper_log` VALUES (129, '课程类别', 3, 'com.ruoyi.web.controller.course.CourseCategoryController.remove()', 'POST', 1, '13900000001', NULL, '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"120\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:48:35', 157);
INSERT INTO `sys_oper_log` VALUES (130, '课程类别', 1, 'com.ruoyi.web.controller.course.CourseCategoryController.addSave()', 'POST', 1, '13900000001', NULL, '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"悄悄搬家\"],\"categoryType\":[\"course\"],\"orderNum\":[\"7\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 10:48:36', 128);
INSERT INTO `sys_oper_log` VALUES (131, '课程类别', 5, 'com.ruoyi.course.controller.CourseCategoryController.export()', 'POST', 1, 'admin', '研发部门', '/course/category/export', '127.0.0.1', '内网IP', '{\"pageNum\":[\"1\"],\"pageSize\":[\"50\"]}', '{\"msg\":\"5a6235c0-d373-43b6-ba13-64e3a0fa385c_课程类别数据.xlsx\",\"code\":0}', 0, NULL, '2026-10-13 11:00:47', 1561);
INSERT INTO `sys_oper_log` VALUES (132, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"java\"],\"categoryType\":[\"course\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', '{\"msg\":\"新增类别\'java\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 11:00:47', 45);
INSERT INTO `sys_oper_log` VALUES (133, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"搬迁验证类别\"],\"categoryType\":[\"course\"],\"orderNum\":[\"9\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:00:48', 183);
INSERT INTO `sys_oper_log` VALUES (134, '课程类别', 2, 'com.ruoyi.course.controller.CourseCategoryController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"124\"],\"categoryName\":[\"搬迁验证类别改\"],\"categoryType\":[\"course\"],\"orderNum\":[\"8\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:00:48', 218);
INSERT INTO `sys_oper_log` VALUES (135, '课程类别', 3, 'com.ruoyi.course.controller.CourseCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"\"]}', NULL, 1, '未选择要删除的类别数据', '2026-10-13 11:00:48', 4);
INSERT INTO `sys_oper_log` VALUES (136, '课程类别', 3, 'com.ruoyi.course.controller.CourseCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"124\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:00:48', 135);
INSERT INTO `sys_oper_log` VALUES (137, '课程类别', 5, 'com.ruoyi.course.controller.CourseCategoryController.export()', 'POST', 1, 'admin', '研发部门', '/course/category/export', '127.0.0.1', '内网IP', '{\"pageNum\":[\"1\"],\"pageSize\":[\"50\"]}', '{\"msg\":\"42f2ec7f-94a8-4c83-871c-6e248174957d_课程类别数据.xlsx\",\"code\":0}', 0, NULL, '2026-10-13 11:01:47', 8105);
INSERT INTO `sys_oper_log` VALUES (138, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"java\"],\"categoryType\":[\"course\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', '{\"msg\":\"新增类别\'java\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 11:01:54', 7751);
INSERT INTO `sys_oper_log` VALUES (139, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"搬迁验证类别\"],\"categoryType\":[\"course\"],\"orderNum\":[\"9\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:01:58', 9958);
INSERT INTO `sys_oper_log` VALUES (140, '课程类别', 3, 'com.ruoyi.course.controller.CourseCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"\"]}', NULL, 1, '未选择要删除的类别数据', '2026-10-13 11:02:11', 0);
INSERT INTO `sys_oper_log` VALUES (141, '课程类别', 2, 'com.ruoyi.course.controller.CourseCategoryController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"125\"],\"categoryName\":[\"搬迁验证类别改\"],\"categoryType\":[\"course\"],\"orderNum\":[\"8\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:02:11', 8088);
INSERT INTO `sys_oper_log` VALUES (142, '课程类别', 3, 'com.ruoyi.course.controller.CourseCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"125\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:02:12', 1808);
INSERT INTO `sys_oper_log` VALUES (143, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, 'eduadmin', '研发部门', '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"权限验证类别\"],\"categoryType\":[\"course\"],\"orderNum\":[\"99\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:27:21', 246);
INSERT INTO `sys_oper_log` VALUES (144, '课程类别', 2, 'com.ruoyi.course.controller.CourseCategoryController.editSave()', 'POST', 1, 'eduadmin', '研发部门', '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryId\":[\"126\"],\"categoryName\":[\"权限验证类别\"],\"categoryType\":[\"course\"],\"orderNum\":[\"98\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:27:21', 196);
INSERT INTO `sys_oper_log` VALUES (145, '课程类别', 5, 'com.ruoyi.course.controller.CourseCategoryController.export()', 'POST', 1, 'eduadmin', '研发部门', '/course/category/export', '127.0.0.1', '内网IP', '{\"pageNum\":[\"1\"],\"pageSize\":[\"50\"]}', '{\"msg\":\"256b4688-5f89-4b80-9d51-3787d14a9fa7_课程类别数据.xlsx\",\"code\":0}', 0, NULL, '2026-10-13 11:27:23', 1271);
INSERT INTO `sys_oper_log` VALUES (146, '社区类别', 1, 'com.ruoyi.community.controller.CommunityCategoryController.addSave()', 'POST', 1, 'eduadmin', '研发部门', '/community/category/add', '127.0.0.1', '内网IP', '{\"categoryName\":[\"社区权限验证\"],\"categoryType\":[\"article\"],\"orderNum\":[\"99\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:27:23', 132);
INSERT INTO `sys_oper_log` VALUES (147, '课程类别', 3, 'com.ruoyi.course.controller.CourseCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/course/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"126\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:27:25', 274);
INSERT INTO `sys_oper_log` VALUES (148, '社区类别', 3, 'com.ruoyi.community.controller.CommunityCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/community/category/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"127\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 11:27:25', 135);
INSERT INTO `sys_oper_log` VALUES (149, '课程类别', 2, 'com.ruoyi.course.controller.CourseCategoryController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryType\":[\"course\"],\"categoryId\":[\"100\"],\"categoryName\":[\"java\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', '{\"msg\":\"修改类别\'java\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 14:27:15', 123);
INSERT INTO `sys_oper_log` VALUES (150, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryType\":[\"course\"],\"categoryName\":[\"ZZTempTestCat\"],\"orderNum\":[\"99\"],\"status\":[\"0\"],\"remark\":[\"tmp\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 14:27:23', 139);
INSERT INTO `sys_oper_log` VALUES (151, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/category/add', '127.0.0.1', '内网IP', '{\"categoryType\":[\"course\"],\"categoryName\":[\"ZZTempTestCat\"],\"orderNum\":[\"99\"],\"status\":[\"0\"]}', '{\"msg\":\"新增类别\'ZZTempTestCat\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 14:27:23', 39);
INSERT INTO `sys_oper_log` VALUES (152, '课程类别', 2, 'com.ruoyi.course.controller.CourseCategoryController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryType\":[\"course\"],\"categoryId\":[\"100\"],\"categoryName\":[\"ZZTempRename\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', NULL, 1, '不允许修改类别类型', '2026-10-13 14:27:24', 85);
INSERT INTO `sys_oper_log` VALUES (153, '课程类别', 2, 'com.ruoyi.course.controller.CourseCategoryController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/category/edit', '127.0.0.1', '内网IP', '{\"categoryType\":[\"course\"],\"categoryId\":[\"100\"],\"categoryName\":[\"ZZTempRename\"],\"orderNum\":[\"1\"],\"status\":[\"0\"]}', NULL, 1, '不允许修改类别类型', '2026-10-13 14:27:28', 93);
INSERT INTO `sys_oper_log` VALUES (154, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '127.0.0.1', '内网IP', '{\"courseName\":[\"大数据\"],\"categoryId\":[\"101\"],\"coverUrl\":[\"/profile/upload/2026/10/13/曾俊杰-贵州大学_20261013154048A001.png\"],\"intro\":[\"把啊\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"无\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 15:41:00', 696);
INSERT INTO `sys_oper_log` VALUES (155, '课程', 3, 'com.ruoyi.course.controller.CourseController.remove()', 'POST', 1, 'admin', '研发部门', '/course/course/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"100\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 15:41:29', 928);
INSERT INTO `sys_oper_log` VALUES (156, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/category/add', '58.16.41.98', 'XX XX', '{\"categoryName\":[\"测试分类A\"],\"categoryType\":[\"course\"],\"orderNum\":[\"99\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 17:56:41', 70);
INSERT INTO `sys_oper_log` VALUES (157, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/category/add', '58.16.41.98', 'XX XX', '{\"categoryName\":[\"测试分类A\"],\"categoryType\":[\"course\"],\"orderNum\":[\"99\"]}', '{\"msg\":\"新增类别\'测试分类A\'失败，类别名称已存在\",\"code\":500}', 0, NULL, '2026-10-13 17:57:07', 5);
INSERT INTO `sys_oper_log` VALUES (158, '课程类别', 2, 'com.ruoyi.course.controller.CourseCategoryController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/category/edit', '58.16.41.98', 'XX XX', '{\"categoryId\":[\"129\"],\"categoryName\":[\"测试分类A改\"],\"categoryType\":[\"course\"],\"orderNum\":[\"99\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 18:00:34', 28);
INSERT INTO `sys_oper_log` VALUES (159, '课程类别', 3, 'com.ruoyi.course.controller.CourseCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/course/category/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"129\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-13 18:00:49', 21);
INSERT INTO `sys_oper_log` VALUES (160, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, '13900001111', NULL, '/course/category/add', '58.16.41.98', 'XX XX', '{\"categoryName\":[\"越权测试\"],\"categoryType\":[\"course\"],\"orderNum\":[\"99\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 09:16:23', 12);
INSERT INTO `sys_oper_log` VALUES (161, '课程类别', 3, 'com.ruoyi.course.controller.CourseCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/course/category/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"130\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 09:29:51', 15);
INSERT INTO `sys_oper_log` VALUES (162, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '58.16.41.98', 'XX XX', '{\"courseName\":[\"测试课程A\"],\"categoryId\":[\"101\"],\"intro\":[\"自动化测试\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 09:50:50', 13);
INSERT INTO `sys_oper_log` VALUES (163, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '58.16.41.98', 'XX XX', '{\"courseName\":[\"测试课程A\"],\"categoryId\":[\"101\"],\"intro\":[\"自动化测试\"],\"status\":[\"0\"]}', '{\"msg\":\"新增课程\'测试课程A\'失败，课程名称已存在\",\"code\":500}', 0, NULL, '2026-10-14 09:50:57', 16);
INSERT INTO `sys_oper_log` VALUES (164, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '58.16.41.98', 'XX XX', '{\"courseId\":[\"101\"],\"courseName\":[\"测试课程A改\"],\"categoryId\":[\"101\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 09:53:56', 17);
INSERT INTO `sys_oper_log` VALUES (165, '课程类别', 1, 'com.ruoyi.course.controller.CourseCategoryController.addSave()', 'POST', 1, '13900001111', NULL, '/course/category/add', '58.16.41.98', 'XX XX', '{\"categoryName\":[\"越权回归\"],\"categoryType\":[\"course\"],\"orderNum\":[\"99\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 10:50:21', 74);
INSERT INTO `sys_oper_log` VALUES (166, '课程类别', 3, 'com.ruoyi.course.controller.CourseCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/course/category/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"131\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 10:54:09', 22);
INSERT INTO `sys_oper_log` VALUES (167, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, '13900001111', NULL, '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"回归测试帖\"],\"categoryId\":[\"100\"],\"content\":[\"测试内容\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:27:41', 58);
INSERT INTO `sys_oper_log` VALUES (168, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, '13900001111', NULL, '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"100\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:29:19', 33);
INSERT INTO `sys_oper_log` VALUES (169, '课程章节', 1, 'com.ruoyi.course.controller.CourseChapterController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/chapter/add', '58.16.41.98', 'XX XX', '{\"courseId\":[\"101\"],\"chapterTitle\":[\"第一章\"],\"chapterContent\":[\"章节内容测试\"],\"orderNum\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:34:17', 11);
INSERT INTO `sys_oper_log` VALUES (170, '课程章节', 2, 'com.ruoyi.course.controller.CourseChapterController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/chapter/edit', '58.16.41.98', 'XX XX', '{\"chapterId\":[\"100\"],\"courseId\":[\"101\"],\"chapterTitle\":[\"第一章改\"],\"chapterContent\":[\"改后内容\"],\"orderNum\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:36:33', 12);
INSERT INTO `sys_oper_log` VALUES (171, '课程视频', 1, 'com.ruoyi.course.controller.CourseVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/video/add', '58.16.41.98', 'XX XX', '{\"courseId\":[\"101\"],\"videoTitle\":[\"第一课视频\"],\"videoUrl\":[\"http://example.com/v1.mp4\"],\"orderNum\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:36:47', 11);
INSERT INTO `sys_oper_log` VALUES (172, '课程视频', 2, 'com.ruoyi.course.controller.CourseVideoController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/video/edit', '58.16.41.98', 'XX XX', '{\"videoId\":[\"100\"],\"courseId\":[\"101\"],\"videoTitle\":[\"第一课视频改\"],\"videoUrl\":[\"http://example.com/v2.mp4\"],\"orderNum\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:38:55', 13);
INSERT INTO `sys_oper_log` VALUES (173, '课程视频', 3, 'com.ruoyi.course.controller.CourseVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/course/video/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"xxx\"]}', NULL, 1, '视频ID[null]不存在或已被删除', '2026-10-14 11:39:03', 5);
INSERT INTO `sys_oper_log` VALUES (174, '课程章节', 3, 'com.ruoyi.course.controller.CourseChapterController.remove()', 'POST', 1, 'admin', '研发部门', '/course/chapter/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"100\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:39:11', 19);
INSERT INTO `sys_oper_log` VALUES (175, '课程', 3, 'com.ruoyi.course.controller.CourseController.remove()', 'POST', 1, 'admin', '研发部门', '/course/course/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"101\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:39:19', 22);
INSERT INTO `sys_oper_log` VALUES (176, '课程视频', 3, 'com.ruoyi.course.controller.CourseVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/course/video/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"xxx\"]}', NULL, 1, '视频ID[null]不存在或已被删除', '2026-10-14 11:39:29', 5);
INSERT INTO `sys_oper_log` VALUES (177, '课程视频', 3, 'com.ruoyi.course.controller.CourseVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/course/video/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"100\"]}', NULL, 1, '视频ID[100]不存在或已被删除', '2026-10-14 11:40:12', 5);
INSERT INTO `sys_oper_log` VALUES (178, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"管理员的帖子\"],\"categoryId\":[\"100\"],\"content\":[\"帖子内容测试\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:43:20', 9);
INSERT INTO `sys_oper_log` VALUES (179, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"管理员的草稿\"],\"categoryId\":[\"100\"],\"content\":[\"\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:43:25', 9);
INSERT INTO `sys_oper_log` VALUES (180, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, 'admin', '研发部门', '/community/post/edit', '58.16.41.98', 'XX XX', '{\"postId\":[\"101\"],\"postTitle\":[\"管理员的帖子改\"],\"categoryId\":[\"100\"],\"content\":[\"改后内容\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:44:27', 12);
INSERT INTO `sys_oper_log` VALUES (181, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, 'admin', '研发部门', '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"102\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:45:16', 14);
INSERT INTO `sys_oper_log` VALUES (182, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, '13900001111', NULL, '/community/post/edit', '58.16.41.98', 'XX XX', '{\"postId\":[\"101\"],\"postTitle\":[\"越权改帖\"],\"categoryId\":[\"100\"],\"content\":[\"恶意修改\"],\"status\":[\"0\"]}', NULL, 1, '只能修改自己发布的帖子', '2026-10-14 11:46:39', 5);
INSERT INTO `sys_oper_log` VALUES (183, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, '13900001111', NULL, '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"101\"]}', NULL, 1, '帖子[管理员的帖子改]不是本人发布，不能删除', '2026-10-14 11:46:52', 6);
INSERT INTO `sys_oper_log` VALUES (184, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, '13900001111', NULL, '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"139的帖子\"],\"categoryId\":[\"100\"],\"content\":[\"我自己的内容\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:49:50', 9);
INSERT INTO `sys_oper_log` VALUES (185, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, '13900001111', NULL, '/community/post/edit', '58.16.41.98', 'XX XX', '{\"postId\":[\"103\"],\"postTitle\":[\"139的帖子改\"],\"categoryId\":[\"100\"],\"content\":[\"我改的\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:51:12', 11);
INSERT INTO `sys_oper_log` VALUES (186, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, '13900001111', NULL, '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"103\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:52:27', 20);
INSERT INTO `sys_oper_log` VALUES (187, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, '13900001111', NULL, '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"101\"]}', NULL, 1, '帖子[管理员的帖子改]不是本人发布，不能删除', '2026-10-14 11:52:34', 5);
INSERT INTO `sys_oper_log` VALUES (188, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.addSave()', 'POST', 1, 'admin', '研发部门', '/system/user/add', '58.16.41.98', 'XX XX', '{\"loginName\":[\"testuser02\"],\"userName\":[\"测试用户02\"],\"roleIds\":[\"2\"],\"deptId\":[\"103\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 11:57:57', 21);
INSERT INTO `sys_oper_log` VALUES (189, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.editSave()', 'POST', 1, 'admin', '研发部门', '/system/user/edit', '58.16.41.98', 'XX XX', '{\"userId\":[\"110\"],\"loginName\":[\"testuser02\"],\"userName\":[\"测试用户02改\"],\"deptId\":[\"103\"],\"roleIds\":[\"2\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 13:57:29', 33);
INSERT INTO `sys_oper_log` VALUES (190, '用户管理', 3, 'com.ruoyi.web.controller.system.SysUserController.remove()', 'POST', 1, 'admin', '研发部门', '/system/user/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"110\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 13:57:40', 12);
INSERT INTO `sys_oper_log` VALUES (191, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.update()', 'POST', 1, '13900001111', NULL, '/system/user/profile/update', '58.16.41.98', 'XX XX', '{\"userName\":[\"测试昵称\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 14:01:13', 14);
INSERT INTO `sys_oper_log` VALUES (192, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.update()', 'POST', 1, '13900001111', NULL, '/system/user/profile/update', '58.16.41.98', 'XX XX', '{\"userName\":[\"13900001111\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 14:01:19', 21);
INSERT INTO `sys_oper_log` VALUES (193, '重置密码', 2, 'com.ruoyi.web.controller.system.SysProfileController.resetPwd()', 'POST', 1, 'eduadmin', '研发部门', '/system/user/profile/resetPwd', '127.0.0.1', '内网IP', '{\"userId\":[\"104\"],\"loginName\":[\"eduadmin\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 14:16:40', 228);
INSERT INTO `sys_oper_log` VALUES (194, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'eduadmin', '研发部门', '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"1\"],\"videoUrl\":[\"/profile/upload/2026/10/14/反恐精英：全球攻势 2024-12-06 20-06-30_20261014141955A002.mp4\"],\"coverUrl\":[\"/profile/upload/2026/10/14/Capture001_20261014141953A001.png\"],\"intro\":[\"wqqwe\"],\"duration\":[\"30\"],\"viewCount\":[\"0\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 14:20:13', 1541);
INSERT INTO `sys_oper_log` VALUES (195, '短视频', 5, 'com.ruoyi.video.controller.ShortVideoController.export()', 'POST', 1, 'eduadmin', '研发部门', '/video/shortvideo/export', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"\"],\"status\":[\"\"],\"orderByColumn\":[\"createTime\"],\"isAsc\":[\"asc\"]}', '{\"msg\":\"819d7f3a-fac6-4d62-89b9-cf53bc4ef458_短视频数据.xlsx\",\"code\":0}', 0, NULL, '2026-10-14 14:23:13', 1182);
INSERT INTO `sys_oper_log` VALUES (196, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'eduadmin', '研发部门', '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"100\"],\"videoTitle\":[\"1\"],\"videoUrl\":[\"/profile/upload/2026/10/14/反恐精英：全球攻势 2024-12-06 20-06-30_20261014141955A002.mp4\"],\"coverUrl\":[\"/profile/upload/2026/10/14/Capture001_20261014141953A001.png\"],\"intro\":[\"wqqwe\"],\"duration\":[\"301\"],\"viewCount\":[\"0\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 14:25:57', 291);
INSERT INTO `sys_oper_log` VALUES (197, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'eduadmin', '研发部门', '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"100\"],\"videoTitle\":[\"212312321\"],\"videoUrl\":[\"/profile/upload/2026/10/14/反恐精英：全球攻势 2024-12-06 20-06-30_20261014141955A002.mp4\"],\"coverUrl\":[\"/profile/upload/2026/10/14/Capture001_20261014141953A001.png\"],\"intro\":[\"wqqwe\"],\"duration\":[\"301\"],\"viewCount\":[\"0\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-14 14:30:49', 472);
INSERT INTO `sys_oper_log` VALUES (198, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"  审计用例A  \"],\"videoUrl\":[\"/profile/upload/2026/10/15/oss-probe_20261015092750A001.png\"],\"coverUrl\":[\"/profile/upload/2026/10/15/oss-probe_20261015092750A001.png\"],\"duration\":[\"30\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 09:27:51', 394);
INSERT INTO `sys_oper_log` VALUES (199, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\" 审计用例A \"],\"videoUrl\":[\"/profile/upload/2026/10/15/oss-probe_20261015092750A001.png\"],\"duration\":[\"30\"],\"status\":[\"0\"]}', '{\"msg\":\"新增短视频失败，视频标题已存在\",\"code\":500}', 0, NULL, '2026-10-15 09:27:51', 82);
INSERT INTO `sys_oper_log` VALUES (200, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"审计用例B\"],\"videoUrl\":[\"https://evil/x.mp4\"],\"duration\":[\"30\"],\"status\":[\"0\"]}', NULL, 1, '视频地址必须是上传接口返回的地址，请重新上传', '2026-10-15 09:27:51', 158);
INSERT INTO `sys_oper_log` VALUES (201, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"审计用例C\"],\"duration\":[\"30\"],\"status\":[\"0\"]}', NULL, 1, '请先上传视频文件', '2026-10-15 09:27:52', 143);
INSERT INTO `sys_oper_log` VALUES (202, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"审计用例D\"],\"videoUrl\":[\"/profile/upload/2026/10/15/oss-probe_20261015092750A001.png\"],\"coverUrl\":[\"x\' onerror=\'alert(1)\"],\"duration\":[\"30\"],\"status\":[\"0\"]}', NULL, 1, '封面地址必须是上传接口返回的地址，请重新上传', '2026-10-15 09:27:52', 157);
INSERT INTO `sys_oper_log` VALUES (203, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"审计用例B\"],\"videoUrl\":[\"https://evil/x.mp4\"],\"duration\":[\"30\"],\"status\":[\"0\"]}', NULL, 1, '视频地址必须是上传接口返回的地址，请重新上传', '2026-10-15 09:28:07', 1207);
INSERT INTO `sys_oper_log` VALUES (204, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"审计用例C\"],\"duration\":[\"30\"],\"status\":[\"0\"]}', NULL, 1, '请先上传视频文件', '2026-10-15 09:28:08', 152);
INSERT INTO `sys_oper_log` VALUES (205, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"审计用例D\"],\"videoUrl\":[\"/profile/upload/2026/10/15/oss-probe_20261015092750A001.png\"],\"coverUrl\":[\"x\' onerror=\'alert(1)\"],\"duration\":[\"30\"],\"status\":[\"0\"]}', NULL, 1, '封面地址必须是上传接口返回的地址，请重新上传', '2026-10-15 09:28:08', 182);
INSERT INTO `sys_oper_log` VALUES (206, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"999999\"],\"videoTitle\":[\"随便\"],\"videoUrl\":[\"/profile/upload/2026/10/15/oss-probe_20261015092750A001.png\"],\"duration\":[\"30\"],\"status\":[\"0\"]}', NULL, 1, '短视频不存在或已被删除', '2026-10-15 09:28:09', 301);
INSERT INTO `sys_oper_log` VALUES (207, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"101\"],\"videoTitle\":[\"审计用例A改\"],\"videoUrl\":[\"/profile/upload/2026/10/15/oss-probe_20261015092750A001.png\"],\"coverUrl\":[\"/profile/upload/2026/10/15/oss-probe_20261015092750A001.png\"],\"duration\":[\"45\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 09:28:10', 630);
INSERT INTO `sys_oper_log` VALUES (208, '短视频', 3, 'com.ruoyi.video.controller.ShortVideoController.remove()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"\"]}', NULL, 1, '未选择要删除的短视频数据', '2026-10-15 09:28:10', 83);
INSERT INTO `sys_oper_log` VALUES (209, '短视频', 3, 'com.ruoyi.video.controller.ShortVideoController.remove()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"101\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 09:28:11', 249);
INSERT INTO `sys_oper_log` VALUES (210, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, '13900000001', NULL, '/community/post/add', '127.0.0.1', '内网IP', '{\"postTitle\":[\"审计用例帖子\"],\"content\":[\"回归测试正文\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 09:28:20', 135);
INSERT INTO `sys_oper_log` VALUES (211, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, '13900000001', NULL, '/community/post/edit', '127.0.0.1', '内网IP', '{\"postId\":[\"45940\"],\"postTitle\":[\"审计用例帖子改\"],\"content\":[\"回归测试正文2\"],\"status\":[\"0\"]}', NULL, 1, '帖子不存在或已被删除', '2026-10-15 09:28:20', 91);
INSERT INTO `sys_oper_log` VALUES (212, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, '13900000001', NULL, '/community/post/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"45940\"]}', NULL, 1, '帖子ID[45940]不存在或已被删除', '2026-10-15 09:28:21', 187);
INSERT INTO `sys_oper_log` VALUES (213, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, '13900000001', NULL, '/community/post/edit', '127.0.0.1', '内网IP', '{\"postId\":[\"105\"],\"postTitle\":[\"审计用例帖子改\"],\"content\":[\"回归测试正文2\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 09:28:30', 216);
INSERT INTO `sys_oper_log` VALUES (214, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, '13900000001', NULL, '/community/post/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"105\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 09:28:31', 508);
INSERT INTO `sys_oper_log` VALUES (215, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, '13900000001', NULL, '/video/shortvideo/add', '127.0.0.1', '内网IP', '{\"videoTitle\":[\"OSS用例\"],\"videoUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/15/oss-probe_20261015101530A001.png\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/15/oss-probe_20261015101530A001.png\"],\"duration\":[\"30\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 10:15:32', 403);
INSERT INTO `sys_oper_log` VALUES (216, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频A\"],\"videoUrl\":[\"/profile/upload/2026/10/15/test.mp4\"],\"intro\":[\"自动化测试\"],\"duration\":[\"30\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 10:55:47', 96);
INSERT INTO `sys_oper_log` VALUES (217, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频A\"],\"videoUrl\":[\"/profile/upload/2026/10/15/test2.mp4\"],\"status\":[\"0\"]}', '{\"msg\":\"新增短视频失败，视频标题已存在\",\"code\":500}', 0, NULL, '2026-10-15 10:55:53', 6);
INSERT INTO `sys_oper_log` VALUES (218, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/edit', '58.16.41.98', 'XX XX', '{\"videoId\":[\"103\"],\"videoTitle\":[\"测试短视频A改\"],\"videoUrl\":[\"/profile/upload/2026/10/15/test.mp4\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 10:59:34', 27);
INSERT INTO `sys_oper_log` VALUES (219, '短视频', 3, 'com.ruoyi.video.controller.ShortVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"103\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 10:59:52', 11);
INSERT INTO `sys_oper_log` VALUES (220, '短视频', 3, 'com.ruoyi.video.controller.ShortVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"xxx\"]}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2026-10-15 10:59:57', 4);
INSERT INTO `sys_oper_log` VALUES (221, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"白名单测试\"],\"videoUrl\":[\"http://evil.com/x.mp4\"],\"status\":[\"0\"]}', NULL, 1, '视频地址必须是上传接口返回的地址，请重新上传', '2026-10-15 11:10:52', 8);
INSERT INTO `sys_oper_log` VALUES (222, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"白名单测试2\"],\"videoUrl\":[\"http://evil.com/x.mp4\"],\"status\":[\"0\"]}', NULL, 1, '视频地址必须是上传接口返回的地址，请重新上传', '2026-10-15 11:22:20', 6);
INSERT INTO `sys_oper_log` VALUES (223, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"边界草稿\"],\"categoryId\":[\"100\"],\"content\":[\"\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 11:23:27', 12);
INSERT INTO `sys_oper_log` VALUES (224, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, 'admin', '研发部门', '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"106\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 11:27:30', 26);
INSERT INTO `sys_oper_log` VALUES (225, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, '13900000001', NULL, '/community/post/edit', '127.0.0.1', '内网IP', '{\"postId\":[\"999999\"],\"postTitle\":[\"x\"],\"content\":[\"y\"],\"status\":[\"0\"]}', NULL, 1, '帖子不存在或已被删除', '2026-10-15 14:04:39', 169);
INSERT INTO `sys_oper_log` VALUES (226, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, '13900000001', NULL, '/community/post/edit', '127.0.0.1', '内网IP', '{\"postId\":[\"999999\"],\"postTitle\":[\"x\"],\"content\":[\"y\"],\"status\":[\"0\"]}', NULL, 1, '帖子不存在或已被删除', '2026-10-15 14:04:39', 44);
INSERT INTO `sys_oper_log` VALUES (227, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, '13900000001', NULL, '/community/post/add', '127.0.0.1', '内网IP', '{\"postTitle\":[\"报告核实用草稿\"],\"content\":[\"draft\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 14:04:39', 90);
INSERT INTO `sys_oper_log` VALUES (228, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"搜索测试A\"],\"videoUrl\":[\"/profile/upload/2026/10/15/sa.mp4\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 16:09:05', 35);
INSERT INTO `sys_oper_log` VALUES (229, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"搜索测试B\"],\"videoUrl\":[\"/profile/upload/2026/10/15/sb.mp4\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 16:09:11', 21);
INSERT INTO `sys_oper_log` VALUES (230, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"搜索测试帖\"],\"categoryId\":[\"100\"],\"content\":[\"搜索测试内容\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 16:09:17', 10);
INSERT INTO `sys_oper_log` VALUES (231, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"搜索草稿帖\"],\"categoryId\":[\"100\"],\"content\":[\"\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 16:09:22', 14);
INSERT INTO `sys_oper_log` VALUES (232, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '58.16.41.98', 'XX XX', '{\"courseName\":[\"搜索测试课程\"],\"categoryId\":[\"101\"],\"intro\":[\"搜索测试\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 16:09:30', 12);
INSERT INTO `sys_oper_log` VALUES (233, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/edit', '58.16.41.98', 'XX XX', '{\"videoId\":[\"105\"],\"videoTitle\":[\"搜索测试B\"],\"videoUrl\":[\"/profile/upload/2026/10/15/sb.mp4\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 16:12:19', 19);
INSERT INTO `sys_oper_log` VALUES (234, '短视频', 3, 'com.ruoyi.video.controller.ShortVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"104,105\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 16:12:30', 14);
INSERT INTO `sys_oper_log` VALUES (235, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, 'admin', '研发部门', '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"108\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 16:12:34', 17);
INSERT INTO `sys_oper_log` VALUES (236, '课程', 3, 'com.ruoyi.course.controller.CourseController.remove()', 'POST', 1, 'admin', '研发部门', '/course/course/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"102\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 16:12:39', 21);
INSERT INTO `sys_oper_log` VALUES (237, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"孤儿回归\"],\"videoUrl\":[\"/profile/upload/2026/10/15/reg.mp4\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:26:06', 93);
INSERT INTO `sys_oper_log` VALUES (238, '短视频', 3, 'com.ruoyi.video.controller.ShortVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"106\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:26:34', 17);
INSERT INTO `sys_oper_log` VALUES (239, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '58.16.41.98', 'XX XX', '{\"courseName\":[\"分类测试课程A\"],\"categoryId\":[\"101\"],\"intro\":[\"测试\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:29:16', 13);
INSERT INTO `sys_oper_log` VALUES (240, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '58.16.41.98', 'XX XX', '{\"courseName\":[\"分类测试课程B\"],\"categoryId\":[\"101\"],\"intro\":[\"测试\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:29:21', 14);
INSERT INTO `sys_oper_log` VALUES (241, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '58.16.41.98', 'XX XX', '{\"courseName\":[\"分类测试课程C\"],\"categoryId\":[\"101\"],\"intro\":[\"测试\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:29:40', 13);
INSERT INTO `sys_oper_log` VALUES (242, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '58.16.41.98', 'XX XX', '{\"courseId\":[\"105\"],\"courseName\":[\"分类测试课程C\"],\"categoryId\":[\"101\"],\"intro\":[\"测试\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:35:06', 23);
INSERT INTO `sys_oper_log` VALUES (243, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, '13900001111', NULL, '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"审核测试帖\"],\"categoryId\":[\"100\"],\"content\":[\"审核测试内容\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:39:34', 10);
INSERT INTO `sys_oper_log` VALUES (244, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '58.16.41.98', 'XX XX', '{\"postId\":[\"110\"],\"status\":[\"0\"],\"isFeatured\":[\"1\"],\"auditRemark\":[\"内容合格通过\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:48:31', 17);
INSERT INTO `sys_oper_log` VALUES (245, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, '13900001111', NULL, '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"审核驳回帖\"],\"categoryId\":[\"100\"],\"content\":[\"驳回测试内容\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:50:01', 16);
INSERT INTO `sys_oper_log` VALUES (246, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '58.16.41.98', 'XX XX', '{\"postId\":[\"110\"],\"status\":[\"4\"],\"auditRemark\":[\"重复审核\"]}', NULL, 1, '该帖子不在待审核状态，不能审核', '2026-10-15 17:50:45', 7);
INSERT INTO `sys_oper_log` VALUES (247, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '58.16.41.98', 'XX XX', '{\"postId\":[\"111\"],\"status\":[\"4\"],\"auditRemark\":[\"内容不合规\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:52:19', 11);
INSERT INTO `sys_oper_log` VALUES (248, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, 'admin', '研发部门', '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"109,110,111\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:56:05', 23);
INSERT INTO `sys_oper_log` VALUES (249, '课程', 3, 'com.ruoyi.course.controller.CourseController.remove()', 'POST', 1, 'admin', '研发部门', '/course/course/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"103,104,105\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-15 17:56:11', 33);
INSERT INTO `sys_oper_log` VALUES (250, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, '13900000001', NULL, '/community/post/add', '127.0.0.1', '内网IP', '{\"postTitle\":[\"修复核实用草稿\"],\"content\":[\"draft\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-16 14:15:54', 333);
INSERT INTO `sys_oper_log` VALUES (251, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, '13900000001', NULL, '/community/post/edit', '127.0.0.1', '内网IP', '{\"postId\":[\"999999\"],\"postTitle\":[\"x\"],\"content\":[\"y\"],\"status\":[\"0\"]}', NULL, 1, '帖子不存在或已被删除', '2026-10-16 14:15:55', 49);
INSERT INTO `sys_oper_log` VALUES (252, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '58.16.41.98', 'XX XX', '{\"courseName\":[\"评分回归课程\"],\"categoryId\":[\"101\"],\"intro\":[\"回归\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-16 14:49:25', 78);
INSERT INTO `sys_oper_log` VALUES (253, '课程', 3, 'com.ruoyi.course.controller.CourseController.remove()', 'POST', 1, 'admin', '研发部门', '/course/course/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"107\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-16 14:50:14', 31);
INSERT INTO `sys_oper_log` VALUES (254, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"提示语回归草稿\"],\"categoryId\":[\"100\"],\"content\":[\"草稿\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-16 14:51:01', 14);
INSERT INTO `sys_oper_log` VALUES (255, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, 'admin', '研发部门', '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"113\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-16 15:04:43', 21);
INSERT INTO `sys_oper_log` VALUES (256, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '58.16.41.98', 'XX XX', '{\"postTitle\":[\"笔记草稿测试\"],\"categoryId\":[\"100\"],\"content\":[\"草稿\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-19 11:38:36', 30);
INSERT INTO `sys_oper_log` VALUES (257, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, 'admin', '研发部门', '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"101\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-19 11:44:31', 30);
INSERT INTO `sys_oper_log` VALUES (258, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, 'admin', '研发部门', '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"119\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-19 11:51:57', 15);
INSERT INTO `sys_oper_log` VALUES (259, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, 'admin', '研发部门', '/community/post/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"101\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-19 14:08:42', 20);
INSERT INTO `sys_oper_log` VALUES (260, '轮播图', 1, 'com.ruoyi.course.controller.BannerController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/add', '54.251.198.55', 'XX XX', '{\"categoryId\":[\"0\"],\"title\":[\"测试新增轮播-可删\"],\"imageUrl\":[\"/profile/test-add.jpg\"],\"courseId\":[\"201\"],\"orderNum\":[\"5\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-21 10:12:20', 24);
INSERT INTO `sys_oper_log` VALUES (261, '轮播图', 1, 'com.ruoyi.course.controller.BannerController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/add', '54.251.198.55', 'XX XX', '{\"categoryId\":[\"103\"],\"title\":[\"跨类测试\"],\"imageUrl\":[\"/x.jpg\"],\"courseId\":[\"201\"],\"status\":[\"0\"]}', NULL, 1, '课程「Java 从入门到实战」属于类别「java」，不能放入类别「mysql」的轮播；请改选「全部」或更换课程', '2026-10-21 10:12:20', 10);
INSERT INTO `sys_oper_log` VALUES (262, '轮播图', 1, 'com.ruoyi.course.controller.BannerController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/add', '54.251.198.55', 'XX XX', '{\"categoryId\":[\"0\"],\"title\":[\"坏课测试\"],\"imageUrl\":[\"/x.jpg\"],\"courseId\":[\"99999\"],\"status\":[\"0\"]}', NULL, 1, '跳转课程不存在或已被删除', '2026-10-21 10:12:21', 4);
INSERT INTO `sys_oper_log` VALUES (263, '轮播图', 1, 'com.ruoyi.course.controller.BannerController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/add', '54.251.198.55', 'XX XX', '{\"categoryId\":[\"888\"],\"title\":[\"坏类测试\"],\"imageUrl\":[\"/x.jpg\"],\"courseId\":[\"201\"],\"status\":[\"0\"]}', NULL, 1, '所属类别不存在或不属于课程模块', '2026-10-21 10:12:21', 3);
INSERT INTO `sys_oper_log` VALUES (264, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '54.251.198.55', 'XX XX', '{\"bannerId\":[\"311\"],\"categoryId\":[\"0\"],\"title\":[\"测试修改轮播\"],\"imageUrl\":[\"/x2.jpg\"],\"courseId\":[\"202\"],\"orderNum\":[\"6\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-21 10:12:21', 16);
INSERT INTO `sys_oper_log` VALUES (265, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '54.251.198.55', 'XX XX', '{\"ids\":[\"311\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-21 10:12:21', 12);
INSERT INTO `sys_oper_log` VALUES (266, '短视频', 3, 'com.ruoyi.video.controller.ShortVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/remove', '42.200.173.215', 'XX XX', '{\"ids\":[\"202\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-22 10:54:49', 31);
INSERT INTO `sys_oper_log` VALUES (267, '短视频', 3, 'com.ruoyi.video.controller.ShortVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/remove', '42.200.173.215', 'XX XX', '{\"ids\":[\"202\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-22 10:57:56', 12);
INSERT INTO `sys_oper_log` VALUES (268, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '127.0.0.1', '内网IP', '{\"courseId\":[\"203\"],\"courseName\":[\"Redis 缓存原理与实战\"],\"categoryId\":[\"105\"],\"coverUrl\":[\"/profile/upload/2026/10/26/R-C_20261026210211A001.jpg\"],\"intro\":[\"Redis 数据类型、持久化与缓存穿透/击穿/雪崩解决方案\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"测试数据-前端调试\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:02:03', 329);
INSERT INTO `sys_oper_log` VALUES (269, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"201\"],\"videoTitle\":[\"Sintel 开源短片 · 片段一\"],\"videoUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-1.mp4\"],\"coverUrl\":[\"/profile/upload/2026/10/26/R-C_20261026212117A002.jpg\"],\"intro\":[\"开源动画短片 Sintel 精彩片段\"],\"duration\":[\"52\"],\"viewCount\":[\"1\"],\"commentCount\":[\"2\"],\"status\":[\"0\"],\"remark\":[\"\"]}', NULL, 1, '视频地址必须是上传接口返回的地址，请重新上传', '2026-10-27 10:21:08', 393);
INSERT INTO `sys_oper_log` VALUES (270, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"100\"],\"videoTitle\":[\"212312321\"],\"videoUrl\":[\"/profile/upload/2026/10/14/反恐精英：全球攻势 2024-12-06 20-06-30_20261014141955A002.mp4\"],\"coverUrl\":[\"/profile/upload/2026/10/26/R-C_20261026212151A003.jpg\"],\"intro\":[\"wqqwe\"],\"duration\":[\"301\"],\"viewCount\":[\"0\"],\"commentCount\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:21:40', 371);
INSERT INTO `sys_oper_log` VALUES (271, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"301\"],\"title\":[\"首页轮播A\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"/profile/upload/2026/10/26/R-C_20261026214611A004.jpg\"],\"courseId\":[\"201\"],\"orderNum\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"轮播图测试数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:45:59', 237);
INSERT INTO `sys_oper_log` VALUES (272, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"302\"],\"title\":[\"首页轮播B\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"/profile/upload/banner-b.jpg\"],\"courseId\":[\"202\"],\"orderNum\":[\"2\"],\"status\":[\"0\"],\"remark\":[\"轮播图测试数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:47:01', 169);
INSERT INTO `sys_oper_log` VALUES (273, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"302\"],\"title\":[\"首页轮播B\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"/profile/upload/2026/10/26/2_20261026214727A005.jpg\"],\"courseId\":[\"202\"],\"orderNum\":[\"2\"],\"status\":[\"0\"],\"remark\":[\"轮播图测试数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:47:15', 179);
INSERT INTO `sys_oper_log` VALUES (274, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"309\"],\"title\":[\"孤儿分类窗口\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"/profile/upload/2026/10/26/1_20261026215003A006.jpg\"],\"courseId\":[\"201\"],\"orderNum\":[\"4\"],\"status\":[\"0\"],\"remark\":[\"轮播图测试数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:49:53', 307);
INSERT INTO `sys_oper_log` VALUES (275, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"304\"],\"title\":[\"MySQL课程推荐\"],\"categoryId\":[\"103\"],\"imageUrl\":[\"/profile/upload/2026/10/26/2_20261026215058A007.jpg\"],\"courseId\":[\"202\"],\"orderNum\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"轮播图测试数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:50:47', 258);
INSERT INTO `sys_oper_log` VALUES (276, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"303\"],\"title\":[\"Java课程推荐\"],\"categoryId\":[\"101\"],\"imageUrl\":[\"/profile/upload/2026/10/26/1_20261026215112A008.jpg\"],\"courseId\":[\"201\"],\"orderNum\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"轮播图测试数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:51:01', 253);
INSERT INTO `sys_oper_log` VALUES (277, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '127.0.0.1', '内网IP', '{\"courseId\":[\"202\"],\"courseName\":[\"MySQL 性能优化实战\"],\"categoryId\":[\"103\"],\"coverUrl\":[\"/profile/upload/2026/10/26/2_20261026215158A009.jpg\"],\"intro\":[\"从索引原理到执行计划，实战排查慢查询与 SQL 优化\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"测试数据-前端调试\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:51:48', 248);
INSERT INTO `sys_oper_log` VALUES (278, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '127.0.0.1', '内网IP', '{\"courseId\":[\"201\"],\"courseName\":[\"Java 从入门到实战\"],\"categoryId\":[\"101\"],\"coverUrl\":[\"/profile/upload/2026/10/26/1_20261026215211A010.jpg\"],\"intro\":[\"面向初学者的 Java 系统课程：环境搭建、语法基础、面向对象与集合框架\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"测试数据-前端调试\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 10:52:00', 211);
INSERT INTO `sys_oper_log` VALUES (279, '短视频', 3, 'com.ruoyi.video.controller.ShortVideoController.remove()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"100\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-27 11:06:59', 510);
INSERT INTO `sys_oper_log` VALUES (280, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '127.0.0.1', '内网IP', '{\"courseId\":[\"203\"],\"courseName\":[\"Redis 缓存原理与实战\"],\"categoryId\":[\"105\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/1_20261027203507A001.jpg\"],\"intro\":[\"Redis 数据类型、持久化与缓存穿透/击穿/雪崩解决方案\"],\"likeCount\":[\"100\"],\"favoriteCount\":[\"80\"],\"commentCount\":[\"50\"],\"status\":[\"0\"],\"remark\":[\"测试数据-前端调试\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 09:35:13', 325);
INSERT INTO `sys_oper_log` VALUES (281, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '127.0.0.1', '内网IP', '{\"courseId\":[\"203\"],\"courseName\":[\"Redis 缓存原理与实战\"],\"categoryId\":[\"105\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/1_20261027203507A001.jpg\"],\"intro\":[\"Redis 数据类型、持久化与缓存穿透/击穿/雪崩解决方案\"],\"likeCount\":[\"100\"],\"favoriteCount\":[\"80\"],\"commentCount\":[\"50\"],\"status\":[\"0\"],\"remark\":[\"测试数据-前端调试\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 09:35:44', 347);
INSERT INTO `sys_oper_log` VALUES (282, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '127.0.0.1', '内网IP', '{\"courseId\":[\"203\"],\"courseName\":[\"Redis 缓存原理与实战\"],\"categoryId\":[\"105\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/1_20261027203507A001.jpg\"],\"intro\":[\"Redis 数据类型、持久化与缓存穿透/击穿/雪崩解决方案\"],\"likeCount\":[\"100\"],\"favoriteCount\":[\"80\"],\"commentCount\":[\"50\"],\"status\":[\"0\"],\"remark\":[\"测试数据-前端调试\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 09:36:47', 362);
INSERT INTO `sys_oper_log` VALUES (283, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '127.0.0.1', '内网IP', '{\"courseId\":[\"202\"],\"courseName\":[\"MySQL 性能优化实战\"],\"categoryId\":[\"103\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/2_20261027203926A002.jpg\"],\"intro\":[\"从索引原理到执行计划，实战排查慢查询与 SQL 优化\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"测试数据-前端调试\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 09:39:14', 177);
INSERT INTO `sys_oper_log` VALUES (284, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '127.0.0.1', '内网IP', '{\"courseId\":[\"201\"],\"courseName\":[\"Java 从入门到实战\"],\"categoryId\":[\"101\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/3_20261027203937A003.jpg\"],\"intro\":[\"面向初学者的 Java 系统课程：环境搭建、语法基础、面向对象与集合框架\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"测试数据-前端调试\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 09:39:25', 219);
INSERT INTO `sys_oper_log` VALUES (285, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, 'admin', '研发部门', '/community/post/edit', '127.0.0.1', '内网IP', '{\"postId\":[\"205\"],\"postTitle\":[\"从单体到微服务的架构演进\"],\"categoryId\":[\"108\"],\"content\":[\"服务拆分原则、注册中心选型、网关与配置中心，以及微服务化过程中的常见踩坑记录。\"],\"likeCount\":[\"100\"],\"favoriteCount\":[\"99\"],\"commentCount\":[\"88\"],\"status\":[\"0\"],\"remark\":[\"\"],\"isFeatured\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 09:39:59', 155);
INSERT INTO `sys_oper_log` VALUES (286, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"301\"],\"title\":[\"首页轮播A\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/3_20261027210506A004.jpg\"],\"courseId\":[\"201\"],\"orderNum\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"轮播图测试数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 10:04:54', 262);
INSERT INTO `sys_oper_log` VALUES (287, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"302\"],\"title\":[\"首页轮播B\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/2_20261027210518A005.jpg\"],\"courseId\":[\"202\"],\"orderNum\":[\"2\"],\"status\":[\"0\"],\"remark\":[\"轮播图测试数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 10:05:05', 209);
INSERT INTO `sys_oper_log` VALUES (288, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"309\"],\"title\":[\"孤儿分类窗口\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/1_20261027210545A006.jpg\"],\"courseId\":[\"201\"],\"orderNum\":[\"4\"],\"status\":[\"0\"],\"remark\":[\"轮播图测试数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 10:05:32', 170);
INSERT INTO `sys_oper_log` VALUES (289, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '127.0.0.1', '内网IP', '{\"postId\":[\"211\"],\"status\":[\"0\"],\"isFeatured\":[\"1\"],\"auditRemark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 10:55:52', 405);
INSERT INTO `sys_oper_log` VALUES (290, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, 'admin', '研发部门', '/community/post/edit', '127.0.0.1', '内网IP', '{\"postId\":[\"211\"],\"postTitle\":[\"计算机网络3天速成\"],\"categoryId\":[\"108\"],\"content\":[\"B站搜索计算机网络鱼哥\"],\"likeCount\":[\"100\"],\"favoriteCount\":[\"1\"],\"commentCount\":[\"1\"],\"status\":[\"0\"],\"isFeatured\":[\"1\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 10:57:37', 239);
INSERT INTO `sys_oper_log` VALUES (291, '课程', 3, 'com.ruoyi.course.controller.CourseController.remove()', 'POST', 1, 'admin', '研发部门', '/course/course/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"112\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 11:27:38', 750);
INSERT INTO `sys_oper_log` VALUES (292, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '127.0.0.1', '内网IP', '{\"courseName\":[\"Kafka入门与实践\"],\"categoryId\":[\"107\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/5_20261027222945A003.jpg\"],\"intro\":[\"kafka新手小白入门\"],\"likeCount\":[\"100\"],\"favoriteCount\":[\"80\"],\"commentCount\":[\"50\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 11:29:50', 219);
INSERT INTO `sys_oper_log` VALUES (293, '课程', 1, 'com.ruoyi.course.controller.CourseController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/course/add', '127.0.0.1', '内网IP', '{\"courseName\":[\"计算机网络\"],\"categoryId\":[\"109\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/4_20261027223033A004.jpg\"],\"intro\":[\"计算机网络教程攻破\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-28 11:30:21', 209);
INSERT INTO `sys_oper_log` VALUES (294, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, 'admin', '研发部门', '/community/post/edit', '58.16.41.98', 'XX XX', '{\"postId\":[\"214\"],\"postTitle\":[\"test\"],\"categoryId\":[\"100\"],\"content\":[\"<p>test</p>\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"],\"isFeatured\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-29 09:28:28', 22);
INSERT INTO `sys_oper_log` VALUES (295, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '58.16.41.98', 'XX XX', '{\"postId\":[\"215\"],\"status\":[\"4\"],\"auditRemark\":[\"\"],\"isFeatured\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-29 09:33:17', 11);
INSERT INTO `sys_oper_log` VALUES (296, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, '13900000001', NULL, '/community/post/edit', '58.16.41.98', 'XX XX', '{\"postId\":[\"205\"],\"postTitle\":[\"从单体到微服务的架构演进\"],\"categoryId\":[\"108\"],\"content\":[\"服务拆分原则、注册中心选型、网关与配置中心，以及微服务化过程中的常见踩坑记录。\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 09:58:16', 17);
INSERT INTO `sys_oper_log` VALUES (297, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '127.0.0.1', '内网IP', '{\"postId\":[\"216\"],\"status\":[\"0\"],\"isFeatured\":[\"1\"],\"auditRemark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 14:55:03', 352);
INSERT INTO `sys_oper_log` VALUES (298, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"309\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:10:00', 164);
INSERT INTO `sys_oper_log` VALUES (299, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"308\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:10:39', 182);
INSERT INTO `sys_oper_log` VALUES (300, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"306\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:10:43', 175);
INSERT INTO `sys_oper_log` VALUES (301, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"307\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:10:46', 166);
INSERT INTO `sys_oper_log` VALUES (302, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"301\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:13:35', 135);
INSERT INTO `sys_oper_log` VALUES (303, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"303\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:13:39', 129);
INSERT INTO `sys_oper_log` VALUES (304, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"304\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:13:42', 147);
INSERT INTO `sys_oper_log` VALUES (305, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"305\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:13:44', 119);
INSERT INTO `sys_oper_log` VALUES (306, '轮播图', 3, 'com.ruoyi.course.controller.BannerController.remove()', 'POST', 1, 'admin', '研发部门', '/course/banner/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"302\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:13:47', 127);
INSERT INTO `sys_oper_log` VALUES (307, '轮播图', 1, 'com.ruoyi.course.controller.BannerController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/add', '127.0.0.1', '内网IP', '{\"title\":[\"Java-从入门到实战\"],\"categoryId\":[\"101\"],\"imageUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/1-Java-从入门到实战_20261030171438A018.jpg\"],\"courseId\":[\"201\"],\"orderNum\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:14:59', 187);
INSERT INTO `sys_oper_log` VALUES (308, '轮播图', 1, 'com.ruoyi.course.controller.BannerController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/add', '127.0.0.1', '内网IP', '{\"title\":[\"MySQL-性能优化实战\"],\"categoryId\":[\"103\"],\"imageUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/2-MySQL-性能优化实战_20261030171534A019.jpg\"],\"courseId\":[\"202\"],\"orderNum\":[\"2\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:15:43', 180);
INSERT INTO `sys_oper_log` VALUES (309, '轮播图', 1, 'com.ruoyi.course.controller.BannerController.addSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/add', '127.0.0.1', '内网IP', '{\"title\":[\"Redis-缓存原理与实战\"],\"categoryId\":[\"105\"],\"imageUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/3-Redis-缓存原理与实战_20261030171602A020.jpg\"],\"courseId\":[\"203\"],\"orderNum\":[\"3\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:16:11', 197);
INSERT INTO `sys_oper_log` VALUES (310, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"312\"],\"title\":[\"Java-从入门到实战\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/1-Java-从入门到实战_20261030171438A018.jpg\"],\"courseId\":[\"201\"],\"orderNum\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:26:19', 185);
INSERT INTO `sys_oper_log` VALUES (311, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"313\"],\"title\":[\"MySQL-性能优化实战\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/2-MySQL-性能优化实战_20261030171534A019.jpg\"],\"courseId\":[\"202\"],\"orderNum\":[\"2\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:26:26', 187);
INSERT INTO `sys_oper_log` VALUES (312, '轮播图', 2, 'com.ruoyi.course.controller.BannerController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/banner/edit', '127.0.0.1', '内网IP', '{\"bannerId\":[\"314\"],\"title\":[\"Redis-缓存原理与实战\"],\"categoryId\":[\"0\"],\"imageUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/3-Redis-缓存原理与实战_20261030171602A020.jpg\"],\"courseId\":[\"203\"],\"orderNum\":[\"3\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-10-30 17:26:37', 188);
INSERT INTO `sys_oper_log` VALUES (313, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, 'admin', '研发部门', '/community/post/edit', '18.140.50.255', 'XX XX', '{\"postId\":[\"218\"],\"postTitle\":[\"111111\"],\"categoryId\":[\"100\"],\"content\":[\"11111111111111111111111111111111\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"],\"isFeatured\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 09:34:50', 12);
INSERT INTO `sys_oper_log` VALUES (314, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '18.140.50.255', 'XX XX', '{\"postId\":[\"217\"],\"status\":[\"0\"],\"auditRemark\":[\"\"],\"isFeatured\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 09:35:53', 10);
INSERT INTO `sys_oper_log` VALUES (315, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '18.140.50.255', 'XX XX', '{\"postId\":[\"205\"],\"status\":[\"0\"],\"auditRemark\":[\"\"],\"isFeatured\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 09:35:58', 9);
INSERT INTO `sys_oper_log` VALUES (316, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '18.140.50.255', 'XX XX', '{\"postId\":[\"210\"],\"status\":[\"4\"],\"auditRemark\":[\"\"],\"isFeatured\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 09:36:06', 9);
INSERT INTO `sys_oper_log` VALUES (317, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '18.140.50.255', 'XX XX', '{\"postId\":[\"219\"],\"status\":[\"0\"],\"auditRemark\":[\"\"],\"isFeatured\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 09:48:49', 10);
INSERT INTO `sys_oper_log` VALUES (318, '话题管理', 1, 'com.ruoyi.community.controller.TopicController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/topic/add', '127.0.0.1', '内网IP', '{\"topicName\":[\"后台测试话题\"],\"topicDesc\":[\"测完删除\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 16:18:46', 700);
INSERT INTO `sys_oper_log` VALUES (319, '话题管理', 2, 'com.ruoyi.community.controller.TopicController.editSave()', 'POST', 1, 'admin', '研发部门', '/community/topic/edit', '127.0.0.1', '内网IP', '{\"topicId\":[\"8\"],\"topicName\":[\"后台测试话题2\"],\"topicDesc\":[\"改过\"],\"status\":[\"1\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 16:18:47', 309);
INSERT INTO `sys_oper_log` VALUES (320, '话题管理', 3, 'com.ruoyi.community.controller.TopicController.remove()', 'POST', 1, 'admin', '研发部门', '/community/topic/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"8\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 16:18:48', 230);
INSERT INTO `sys_oper_log` VALUES (321, '话题管理', 1, 'com.ruoyi.community.controller.TopicController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/topic/add', '127.0.0.1', '内网IP', '{\"topicName\":[\"后台测试话题\"],\"topicDesc\":[\"重建\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 16:18:48', 267);
INSERT INTO `sys_oper_log` VALUES (322, '话题管理', 3, 'com.ruoyi.community.controller.TopicController.remove()', 'POST', 1, 'admin', '研发部门', '/community/topic/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"9\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 16:18:49', 244);
INSERT INTO `sys_oper_log` VALUES (323, '话题管理', 3, 'com.ruoyi.community.controller.TopicController.remove()', 'POST', 1, 'admin', '研发部门', '/community/topic/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"1\"]}', NULL, 1, '话题下还有文章，不能删除', '2026-11-02 16:19:04', 185);
INSERT INTO `sys_oper_log` VALUES (324, '评价管理', 3, 'com.ruoyi.course.controller.CourseRatingController.remove()', 'POST', 1, 'admin', '研发部门', '/course/rating/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"120\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-02 16:28:17', 424);
INSERT INTO `sys_oper_log` VALUES (325, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"201\"],\"videoTitle\":[\"Sintel 开源短片 · 片段一\"],\"videoUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-1.mp4\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/04/sintel_20261104145028A001.jpg\"],\"intro\":[\"开源动画短片 Sintel 精彩片段\"],\"duration\":[\"52\"],\"viewCount\":[\"5\"],\"commentCount\":[\"10\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-04 14:50:31', 342);
INSERT INTO `sys_oper_log` VALUES (326, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"202\"],\"videoTitle\":[\"Sintel 开源短片 · 片段二\"],\"videoUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-2.mp4\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/04/sintel_20261104145108A002.jpg\"],\"intro\":[\"开源动画短片 Sintel 精彩片段\"],\"duration\":[\"52\"],\"viewCount\":[\"6\"],\"commentCount\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-04 14:51:08', 318);
INSERT INTO `sys_oper_log` VALUES (327, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"203\"],\"videoTitle\":[\"Sintel 开源短片 · 片段三\"],\"videoUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-3.mp4\"],\"coverUrl\":[\"\"],\"intro\":[\"开源动画短片 Sintel 精彩片段\"],\"duration\":[\"52\"],\"viewCount\":[\"4\"],\"commentCount\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-04 14:51:17', 274);
INSERT INTO `sys_oper_log` VALUES (328, '短视频', 2, 'com.ruoyi.video.controller.ShortVideoController.editSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/edit', '127.0.0.1', '内网IP', '{\"videoId\":[\"203\"],\"videoTitle\":[\"Sintel 开源短片 · 片段三\"],\"videoUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-3.mp4\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/04/sintel_20261104145126A003.jpg\"],\"intro\":[\"开源动画短片 Sintel 精彩片段\"],\"duration\":[\"52\"],\"viewCount\":[\"4\"],\"commentCount\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-04 14:51:26', 278);
INSERT INTO `sys_oper_log` VALUES (329, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.auditSave()', 'POST', 1, 'admin', '研发部门', '/community/post/audit', '127.0.0.1', '内网IP', '{\"postId\":[\"223\"],\"status\":[\"0\"],\"auditRemark\":[\"\"],\"isFeatured\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-04 14:54:45', 132);
INSERT INTO `sys_oper_log` VALUES (330, '课程', 2, 'com.ruoyi.course.controller.CourseController.editSave()', 'POST', 1, 'admin', '研发部门', '/course/course/edit', '58.16.41.98', 'XX XX', '{\"courseId\":[\"201\"],\"courseName\":[\"Java 从入门到实战\"],\"categoryId\":[\"101\"],\"coverUrl\":[\"https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/3_20261027203937A003.jpg\"],\"intro\":[\"面向初学者的 Java 系统课程：环境搭建、语法基础、面向对象与集合框架\"],\"likeCount\":[\"2\"],\"favoriteCount\":[\"3\"],\"commentCount\":[\"3\"],\"status\":[\"0\"],\"remark\":[\"测试数据-前端调试\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-10 09:11:28', 30);
INSERT INTO `sys_oper_log` VALUES (331, '评论查看', 3, 'com.ruoyi.interaction.controller.CommentController.remove()', 'POST', 1, 'admin', '研发部门', '/community/comment/remove', '127.0.0.1', '内网IP', '{\"commentId\":[\"163\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-10 09:39:45', 874);
INSERT INTO `sys_oper_log` VALUES (332, '课程评价', 3, 'com.ruoyi.course.controller.CourseRatingController.remove()', 'POST', 1, 'admin', '研发部门', '/course/rating/remove', '127.0.0.1', '内网IP', '{\"ratingId\":[\"127\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-10 09:39:52', 1431);
INSERT INTO `sys_oper_log` VALUES (333, '评论查看', 3, 'com.ruoyi.interaction.controller.CommentController.remove()', 'POST', 1, 'admin', '研发部门', '/community/comment/remove', '127.0.0.1', '内网IP', '{\"commentId\":[\"164\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-10 09:40:11', 1089);
INSERT INTO `sys_oper_log` VALUES (334, '评论查看', 3, 'com.ruoyi.interaction.controller.CommentController.remove()', 'POST', 1, 'admin', '研发部门', '/community/comment/remove', '127.0.0.1', '内网IP', '{\"commentId\":[\"127\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-10 14:34:36', 607);
INSERT INTO `sys_oper_log` VALUES (335, '评论查看', 3, 'com.ruoyi.interaction.controller.CommentController.remove()', 'POST', 1, 'admin', '研发部门', '/community/comment/remove', '127.0.0.1', '内网IP', '{\"commentId\":[\"124\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-10 14:47:30', 316);
INSERT INTO `sys_oper_log` VALUES (336, '话题管理', 1, 'com.ruoyi.community.controller.TopicController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/topic/add', '58.16.41.98', 'XX XX', '{\"topicName\":[\"#jenkens\"],\"topicDesc\":[\"自动化部署相关\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-11 14:23:44', 38);
INSERT INTO `sys_oper_log` VALUES (337, '话题管理', 2, 'com.ruoyi.community.controller.TopicController.editSave()', 'POST', 1, 'admin', '研发部门', '/community/topic/edit', '58.16.41.98', 'XX XX', '{\"topicId\":[\"10\"],\"topicName\":[\"Jenkens\"],\"topicDesc\":[\"自动化部署相关\"],\"status\":[\"0\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-11 14:23:53', 18);
INSERT INTO `sys_oper_log` VALUES (338, '话题管理', 3, 'com.ruoyi.community.controller.TopicController.remove()', 'POST', 1, 'admin', '研发部门', '/community/topic/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"10\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-11 14:24:02', 22);
INSERT INTO `sys_oper_log` VALUES (339, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频01-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-01_20261113140421A001.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-01_20261113140506A002.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"5\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:05:08', 21);
INSERT INTO `sys_oper_log` VALUES (340, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频02-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-02_20261113140748A003.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-02_20261113140802A004.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"6\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:08:04', 18);
INSERT INTO `sys_oper_log` VALUES (341, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频03-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-03_20261113140819A005.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-03_20261113140820A006.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"4\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:08:22', 11);
INSERT INTO `sys_oper_log` VALUES (342, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频04-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-04_20261113140826A007.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-04_20261113140828A008.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"5\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:08:31', 15);
INSERT INTO `sys_oper_log` VALUES (343, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频05-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-05_20261113140842A009.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-05_20261113140844A010.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"6\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:08:47', 11);
INSERT INTO `sys_oper_log` VALUES (344, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频06-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-06_20261113140851A011.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-06_20261113140852A012.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"4\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:08:54', 14);
INSERT INTO `sys_oper_log` VALUES (345, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频07-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-07_20261113140904A013.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-07_20261113140906A014.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"5\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:09:08', 11);
INSERT INTO `sys_oper_log` VALUES (346, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频08-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-08_20261113140913A015.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-08_20261113140915A016.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"6\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:09:18', 17);
INSERT INTO `sys_oper_log` VALUES (347, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频09-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-09_20261113141111A017.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-09_20261113141118A018.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"4\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:11:21', 11);
INSERT INTO `sys_oper_log` VALUES (348, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频10-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-10_20261113141134A019.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-10_20261113141135A020.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"5\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:11:38', 10);
INSERT INTO `sys_oper_log` VALUES (349, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频11-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-11_20261113141207A022.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-11_20261113141152A021.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"6\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:12:16', 10);
INSERT INTO `sys_oper_log` VALUES (350, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频12-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-12_20261113141231A023.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-12_20261113141232A024.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"4\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:12:34', 10);
INSERT INTO `sys_oper_log` VALUES (351, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频13-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-13_20261113141239A025.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-13_20261113141241A026.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"5\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:12:43', 9);
INSERT INTO `sys_oper_log` VALUES (352, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频14-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-14_20261113141257A027.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-14_20261113141259A028.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"6\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:13:02', 14);
INSERT INTO `sys_oper_log` VALUES (353, '短视频', 1, 'com.ruoyi.video.controller.ShortVideoController.addSave()', 'POST', 1, 'admin', '研发部门', '/video/shortvideo/add', '58.16.41.98', 'XX XX', '{\"videoTitle\":[\"测试短视频15-功能验证\"],\"videoUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/test-video-15_20261113141306A029.mp4\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/13/cover-15_20261113141307A030.jpg\"],\"intro\":[\"自动化测试数据，本地生成素材\"],\"duration\":[\"4\"],\"viewCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"0\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-13 14:13:10', 11);
INSERT INTO `sys_oper_log` VALUES (354, '商城商品', 2, 'com.ruoyi.shopping.controller.ShopProductController.editSave()', 'POST', 1, 'admin', '研发部门', '/shop/product/edit', '58.16.41.98', 'XX XX', '{\"productId\":[\"1\"],\"categoryId\":[\"1\"],\"productName\":[\"无线蓝牙耳机\"],\"coverUrl\":[\"http://43.142.9.214/oss-preview/upload/2026/11/18/OIP_20261118113941A002.jpg\"],\"pointsPrice\":[\"2600\"],\"stock\":[\"20\"],\"orderNum\":[\"1\"],\"status\":[\"0\"],\"description\":[\"轻量化半入耳设计，续航 20 小时，学习通勤两不误。\"],\"remark\":[\"\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 11:39:44', 17);
INSERT INTO `sys_oper_log` VALUES (355, '违禁词', 1, 'com.ruoyi.community.controller.SensitiveWordController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/sensitive-word/add', '127.0.0.1', '内网IP', '{\"word\":[\"测试违禁词\"],\"status\":[\"0\"],\"remark\":[\"测试用\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 11:48:17', 469);
INSERT INTO `sys_oper_log` VALUES (356, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '127.0.0.1', '内网IP', '{\"postTitle\":[\"测试违禁词后台\"],\"categoryId\":[\"100\"],\"content\":[\"后台正常内容\"],\"status\":[\"0\"]}', NULL, 1, '内容包含违禁词，请修改', '2026-11-18 11:48:18', 3);
INSERT INTO `sys_oper_log` VALUES (357, '社区帖子', 2, 'com.ruoyi.community.controller.PostController.editSave()', 'POST', 1, 'admin', '研发部门', '/community/post/edit', '127.0.0.1', '内网IP', '{\"postId\":[\"229\"],\"postTitle\":[\"测试违禁词标题\"],\"categoryId\":[\"100\"],\"content\":[\"正常内容\"],\"status\":[\"3\"]}', NULL, 1, '内容包含违禁词，请修改', '2026-11-18 11:48:29', 61);
INSERT INTO `sys_oper_log` VALUES (358, '违禁词', 3, 'com.ruoyi.community.controller.SensitiveWordController.remove()', 'POST', 1, 'admin', '研发部门', '/community/sensitive-word/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"6\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 11:48:29', 291);
INSERT INTO `sys_oper_log` VALUES (359, '社区帖子', 3, 'com.ruoyi.community.controller.PostController.remove()', 'POST', 1, 'admin', '研发部门', '/community/post/remove', '127.0.0.1', '内网IP', '{\"ids\":[\"229,230\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 11:48:31', 680);
INSERT INTO `sys_oper_log` VALUES (360, '商城商品分类', 1, 'com.ruoyi.shopping.controller.ShopCategoryController.addSave()', 'POST', 1, 'admin', '研发部门', '/shop/category/add', '58.16.41.98', 'XX XX', '{\"categoryName\":[\"测试分类A\"],\"orderNum\":[\"9\"],\"status\":[\"0\"],\"remark\":[\"自动化测试临时数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 14:24:51', 63);
INSERT INTO `sys_oper_log` VALUES (361, '商城商品分类', 2, 'com.ruoyi.shopping.controller.ShopCategoryController.editSave()', 'POST', 1, 'admin', '研发部门', '/shop/category/edit', '58.16.41.98', 'XX XX', '{\"categoryId\":[\"5\"],\"categoryName\":[\"测试分类A改\"],\"orderNum\":[\"10\"],\"status\":[\"0\"],\"remark\":[\"自动化测试-已修改\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 14:25:04', 15);
INSERT INTO `sys_oper_log` VALUES (362, '商城商品分类', 3, 'com.ruoyi.shopping.controller.ShopCategoryController.remove()', 'POST', 1, 'admin', '研发部门', '/shop/category/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"5\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 14:25:16', 25);
INSERT INTO `sys_oper_log` VALUES (363, '商城商品', 1, 'com.ruoyi.shopping.controller.ShopProductController.addSave()', 'POST', 1, 'admin', '研发部门', '/shop/product/add', '58.16.41.98', 'XX XX', '{\"categoryId\":[\"1\"],\"productName\":[\"测试商品A\"],\"pointsPrice\":[\"100\"],\"stock\":[\"5\"],\"orderNum\":[\"99\"],\"status\":[\"0\"],\"remark\":[\"自动化测试临时数据\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 14:25:24', 9);
INSERT INTO `sys_oper_log` VALUES (364, '商城商品', 2, 'com.ruoyi.shopping.controller.ShopProductController.editSave()', 'POST', 1, 'admin', '研发部门', '/shop/product/edit', '58.16.41.98', 'XX XX', '{\"productId\":[\"13\"],\"categoryId\":[\"1\"],\"productName\":[\"测试商品A改\"],\"pointsPrice\":[\"120\"],\"stock\":[\"8\"],\"orderNum\":[\"99\"],\"status\":[\"0\"],\"remark\":[\"自动化测试-已修改\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 14:25:37', 12);
INSERT INTO `sys_oper_log` VALUES (365, '商城商品', 3, 'com.ruoyi.shopping.controller.ShopProductController.remove()', 'POST', 1, 'admin', '研发部门', '/shop/product/remove', '58.16.41.98', 'XX XX', '{\"ids\":[\"13\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 14:25:44', 8);
INSERT INTO `sys_oper_log` VALUES (366, '平台协议', 2, 'com.ruoyi.user.controller.AgreementController.editSave()', 'POST', 1, 'admin', '研发部门', '/user/agreement/edit', '58.16.41.98', 'XX XX', '{\"agreementId\":[\"1\"],\"agreementType\":[\"user_agreement\"],\"title\":[\"用户协议\"],\"content\":[\"null\"],\"orderNum\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"系统初始化\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 14:25:59', 14);
INSERT INTO `sys_oper_log` VALUES (367, '平台协议', 2, 'com.ruoyi.user.controller.AgreementController.editSave()', 'POST', 1, 'admin', '研发部门', '/user/agreement/edit', '58.16.41.98', 'XX XX', '{\"agreementId\":[\"1\"],\"agreementType\":[\"user_agreement\"],\"title\":[\"用户协议\"],\"content\":[\"<h2>用户协议</h2><p>欢迎使用本学习平台。本协议约定您与平台之间的权利与义务，请仔细阅读。</p><p>（内容由管理员在后台「协议管理」中完善）</p>\"],\"orderNum\":[\"1\"],\"status\":[\"0\"],\"remark\":[\"系统初始化\"]}', '{\"msg\":\"操作成功\",\"code\":0}', 0, NULL, '2026-11-18 14:43:39', 72);
INSERT INTO `sys_oper_log` VALUES (368, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '127.0.0.1', '内网IP', '{\"postTitle\":[\"123123\"],\"categoryId\":[\"\"],\"content\":[\"约炮\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"1\"],\"remark\":[\"\"]}', NULL, 1, '内容包含违禁词，请修改', '2026-11-19 09:24:16', 103);
INSERT INTO `sys_oper_log` VALUES (369, '社区帖子', 1, 'com.ruoyi.community.controller.PostController.addSave()', 'POST', 1, 'admin', '研发部门', '/community/post/add', '127.0.0.1', '内网IP', '{\"postTitle\":[\"123123\"],\"categoryId\":[\"\"],\"content\":[\"约炮\"],\"likeCount\":[\"0\"],\"favoriteCount\":[\"0\"],\"commentCount\":[\"0\"],\"status\":[\"1\"],\"remark\":[\"\"]}', NULL, 1, '内容包含违禁词，请修改', '2026-11-19 09:24:20', 2);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-10-13 09:00:51', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-10-13 09:00:51', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '5', '0', '0', 'admin', '2026-10-13 09:00:51', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 1);
INSERT INTO `sys_role_menu` VALUES (1, 2);
INSERT INTO `sys_role_menu` VALUES (1, 3);
INSERT INTO `sys_role_menu` VALUES (1, 4);
INSERT INTO `sys_role_menu` VALUES (1, 100);
INSERT INTO `sys_role_menu` VALUES (1, 101);
INSERT INTO `sys_role_menu` VALUES (1, 102);
INSERT INTO `sys_role_menu` VALUES (1, 103);
INSERT INTO `sys_role_menu` VALUES (1, 104);
INSERT INTO `sys_role_menu` VALUES (1, 105);
INSERT INTO `sys_role_menu` VALUES (1, 106);
INSERT INTO `sys_role_menu` VALUES (1, 107);
INSERT INTO `sys_role_menu` VALUES (1, 108);
INSERT INTO `sys_role_menu` VALUES (1, 109);
INSERT INTO `sys_role_menu` VALUES (1, 110);
INSERT INTO `sys_role_menu` VALUES (1, 111);
INSERT INTO `sys_role_menu` VALUES (1, 112);
INSERT INTO `sys_role_menu` VALUES (1, 113);
INSERT INTO `sys_role_menu` VALUES (1, 114);
INSERT INTO `sys_role_menu` VALUES (1, 115);
INSERT INTO `sys_role_menu` VALUES (1, 116);
INSERT INTO `sys_role_menu` VALUES (1, 500);
INSERT INTO `sys_role_menu` VALUES (1, 501);
INSERT INTO `sys_role_menu` VALUES (1, 1000);
INSERT INTO `sys_role_menu` VALUES (1, 1001);
INSERT INTO `sys_role_menu` VALUES (1, 1002);
INSERT INTO `sys_role_menu` VALUES (1, 1003);
INSERT INTO `sys_role_menu` VALUES (1, 1004);
INSERT INTO `sys_role_menu` VALUES (1, 1005);
INSERT INTO `sys_role_menu` VALUES (1, 1006);
INSERT INTO `sys_role_menu` VALUES (1, 1007);
INSERT INTO `sys_role_menu` VALUES (1, 1008);
INSERT INTO `sys_role_menu` VALUES (1, 1009);
INSERT INTO `sys_role_menu` VALUES (1, 1010);
INSERT INTO `sys_role_menu` VALUES (1, 1011);
INSERT INTO `sys_role_menu` VALUES (1, 1012);
INSERT INTO `sys_role_menu` VALUES (1, 1013);
INSERT INTO `sys_role_menu` VALUES (1, 1014);
INSERT INTO `sys_role_menu` VALUES (1, 1015);
INSERT INTO `sys_role_menu` VALUES (1, 1016);
INSERT INTO `sys_role_menu` VALUES (1, 1017);
INSERT INTO `sys_role_menu` VALUES (1, 1018);
INSERT INTO `sys_role_menu` VALUES (1, 1019);
INSERT INTO `sys_role_menu` VALUES (1, 1020);
INSERT INTO `sys_role_menu` VALUES (1, 1021);
INSERT INTO `sys_role_menu` VALUES (1, 1022);
INSERT INTO `sys_role_menu` VALUES (1, 1023);
INSERT INTO `sys_role_menu` VALUES (1, 1024);
INSERT INTO `sys_role_menu` VALUES (1, 1025);
INSERT INTO `sys_role_menu` VALUES (1, 1026);
INSERT INTO `sys_role_menu` VALUES (1, 1027);
INSERT INTO `sys_role_menu` VALUES (1, 1028);
INSERT INTO `sys_role_menu` VALUES (1, 1029);
INSERT INTO `sys_role_menu` VALUES (1, 1030);
INSERT INTO `sys_role_menu` VALUES (1, 1031);
INSERT INTO `sys_role_menu` VALUES (1, 1032);
INSERT INTO `sys_role_menu` VALUES (1, 1033);
INSERT INTO `sys_role_menu` VALUES (1, 1034);
INSERT INTO `sys_role_menu` VALUES (1, 1035);
INSERT INTO `sys_role_menu` VALUES (1, 1036);
INSERT INTO `sys_role_menu` VALUES (1, 1037);
INSERT INTO `sys_role_menu` VALUES (1, 1038);
INSERT INTO `sys_role_menu` VALUES (1, 1039);
INSERT INTO `sys_role_menu` VALUES (1, 1040);
INSERT INTO `sys_role_menu` VALUES (1, 1041);
INSERT INTO `sys_role_menu` VALUES (1, 1042);
INSERT INTO `sys_role_menu` VALUES (1, 1043);
INSERT INTO `sys_role_menu` VALUES (1, 1044);
INSERT INTO `sys_role_menu` VALUES (1, 1045);
INSERT INTO `sys_role_menu` VALUES (1, 1046);
INSERT INTO `sys_role_menu` VALUES (1, 1047);
INSERT INTO `sys_role_menu` VALUES (1, 1048);
INSERT INTO `sys_role_menu` VALUES (1, 1049);
INSERT INTO `sys_role_menu` VALUES (1, 1050);
INSERT INTO `sys_role_menu` VALUES (1, 1051);
INSERT INTO `sys_role_menu` VALUES (1, 1052);
INSERT INTO `sys_role_menu` VALUES (1, 1053);
INSERT INTO `sys_role_menu` VALUES (1, 1054);
INSERT INTO `sys_role_menu` VALUES (1, 1055);
INSERT INTO `sys_role_menu` VALUES (1, 1056);
INSERT INTO `sys_role_menu` VALUES (1, 1057);
INSERT INTO `sys_role_menu` VALUES (1, 1058);
INSERT INTO `sys_role_menu` VALUES (1, 1059);
INSERT INTO `sys_role_menu` VALUES (1, 1060);
INSERT INTO `sys_role_menu` VALUES (1, 1061);
INSERT INTO `sys_role_menu` VALUES (1, 2018);
INSERT INTO `sys_role_menu` VALUES (1, 2019);
INSERT INTO `sys_role_menu` VALUES (1, 2020);
INSERT INTO `sys_role_menu` VALUES (1, 2021);
INSERT INTO `sys_role_menu` VALUES (1, 2022);
INSERT INTO `sys_role_menu` VALUES (1, 2023);
INSERT INTO `sys_role_menu` VALUES (1, 2024);
INSERT INTO `sys_role_menu` VALUES (1, 2025);
INSERT INTO `sys_role_menu` VALUES (1, 2026);
INSERT INTO `sys_role_menu` VALUES (1, 2027);
INSERT INTO `sys_role_menu` VALUES (1, 2028);
INSERT INTO `sys_role_menu` VALUES (1, 2029);
INSERT INTO `sys_role_menu` VALUES (1, 2030);
INSERT INTO `sys_role_menu` VALUES (1, 2032);
INSERT INTO `sys_role_menu` VALUES (1, 2033);
INSERT INTO `sys_role_menu` VALUES (1, 2034);
INSERT INTO `sys_role_menu` VALUES (1, 2035);
INSERT INTO `sys_role_menu` VALUES (1, 2036);
INSERT INTO `sys_role_menu` VALUES (1, 2037);
INSERT INTO `sys_role_menu` VALUES (1, 2040);
INSERT INTO `sys_role_menu` VALUES (1, 2041);
INSERT INTO `sys_role_menu` VALUES (1, 2042);
INSERT INTO `sys_role_menu` VALUES (1, 2043);
INSERT INTO `sys_role_menu` VALUES (1, 2044);
INSERT INTO `sys_role_menu` VALUES (1, 2048);
INSERT INTO `sys_role_menu` VALUES (1, 2049);
INSERT INTO `sys_role_menu` VALUES (1, 2050);
INSERT INTO `sys_role_menu` VALUES (1, 2051);
INSERT INTO `sys_role_menu` VALUES (1, 2052);
INSERT INTO `sys_role_menu` VALUES (1, 2053);
INSERT INTO `sys_role_menu` VALUES (1, 2056);
INSERT INTO `sys_role_menu` VALUES (1, 2057);
INSERT INTO `sys_role_menu` VALUES (1, 2058);
INSERT INTO `sys_role_menu` VALUES (1, 2059);
INSERT INTO `sys_role_menu` VALUES (1, 2060);
INSERT INTO `sys_role_menu` VALUES (1, 2061);
INSERT INTO `sys_role_menu` VALUES (1, 2069);
INSERT INTO `sys_role_menu` VALUES (1, 2070);
INSERT INTO `sys_role_menu` VALUES (1, 2071);
INSERT INTO `sys_role_menu` VALUES (1, 2072);
INSERT INTO `sys_role_menu` VALUES (1, 2073);
INSERT INTO `sys_role_menu` VALUES (1, 2084);
INSERT INTO `sys_role_menu` VALUES (1, 2088);
INSERT INTO `sys_role_menu` VALUES (1, 2100);
INSERT INTO `sys_role_menu` VALUES (1, 2101);
INSERT INTO `sys_role_menu` VALUES (1, 2102);
INSERT INTO `sys_role_menu` VALUES (1, 2103);
INSERT INTO `sys_role_menu` VALUES (1, 2104);
INSERT INTO `sys_role_menu` VALUES (1, 2105);
INSERT INTO `sys_role_menu` VALUES (1, 2106);
INSERT INTO `sys_role_menu` VALUES (1, 2107);
INSERT INTO `sys_role_menu` VALUES (1, 2108);
INSERT INTO `sys_role_menu` VALUES (1, 2109);
INSERT INTO `sys_role_menu` VALUES (1, 2110);
INSERT INTO `sys_role_menu` VALUES (1, 2111);
INSERT INTO `sys_role_menu` VALUES (1, 2112);
INSERT INTO `sys_role_menu` VALUES (1, 2119);
INSERT INTO `sys_role_menu` VALUES (1, 2120);
INSERT INTO `sys_role_menu` VALUES (1, 2121);
INSERT INTO `sys_role_menu` VALUES (1, 2122);
INSERT INTO `sys_role_menu` VALUES (1, 2128);
INSERT INTO `sys_role_menu` VALUES (1, 2129);
INSERT INTO `sys_role_menu` VALUES (1, 2130);
INSERT INTO `sys_role_menu` VALUES (1, 2131);
INSERT INTO `sys_role_menu` VALUES (1, 2132);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 2026);
INSERT INTO `sys_role_menu` VALUES (2, 2027);
INSERT INTO `sys_role_menu` VALUES (2, 2028);
INSERT INTO `sys_role_menu` VALUES (2, 2029);
INSERT INTO `sys_role_menu` VALUES (2, 2030);
INSERT INTO `sys_role_menu` VALUES (2, 2032);
INSERT INTO `sys_role_menu` VALUES (2, 2033);
INSERT INTO `sys_role_menu` VALUES (2, 2040);
INSERT INTO `sys_role_menu` VALUES (2, 2041);
INSERT INTO `sys_role_menu` VALUES (2, 2042);
INSERT INTO `sys_role_menu` VALUES (2, 2043);
INSERT INTO `sys_role_menu` VALUES (2, 2048);
INSERT INTO `sys_role_menu` VALUES (2, 2049);
INSERT INTO `sys_role_menu` VALUES (2, 2057);
INSERT INTO `sys_role_menu` VALUES (2, 2100);
INSERT INTO `sys_role_menu` VALUES (2, 2101);
INSERT INTO `sys_role_menu` VALUES (2, 2102);
INSERT INTO `sys_role_menu` VALUES (2, 2105);
INSERT INTO `sys_role_menu` VALUES (2, 2106);
INSERT INTO `sys_role_menu` VALUES (2, 2119);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `login_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录账号',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户 01注册用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像地址',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '盐加密',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '29c67a30398638269fe600f73a054934', '111111', '0', '0', '127.0.0.1', '2026-11-19 09:23:28', NULL, 'admin', '2026-10-13 09:00:51', '', NULL, '管理员');
INSERT INTO `sys_user` VALUES (104, 103, 'eduadmin', '平台管理员', '00', 'eduadmin@qq.com', '13800000000', '0', '', 'b7c399189dc25b1f4b61243c6c401997', '30c671', '0', '0', '127.0.0.1', '2026-11-10 11:58:41', '2026-10-14 14:16:39', 'admin', '2026-10-13 11:25:49', '', '2026-10-14 14:16:39', '平台管理员账号');
INSERT INTO `sys_user` VALUES (106, NULL, '13900001111', '13900001111', '01', '', '13900001111', '0', '', '1c3a3325d5951de1ea6648c6854d67a0', 'af4b7a', '0', '0', '18.140.50.255', '2026-11-02 10:53:18', '2026-10-13 15:04:08', '', '2026-10-13 15:04:07', '', '2026-10-14 14:01:19', NULL);
INSERT INTO `sys_user` VALUES (107, NULL, '18085885945', '18085885945', '01', '', '18085885945', '0', '', 'ad563769c7626e452287599a4de61ff3', '839e82', '0', '0', '', NULL, '2026-10-13 15:51:33', '', '2026-10-13 15:51:32', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (108, NULL, '19000000001', '19000000001', '01', '', '19000000001', '0', '', '81054861b6f7e8117d7c498993bd4619', '344e5a', '0', '0', '', NULL, '2026-10-13 16:30:27', '', '2026-10-13 16:30:27', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (109, NULL, '13900007777', '13900007777', '01', '', '13900007777', '0', '', '709d9e7ec87780d9e935ff2f7e9ff034', '47e27a', '0', '0', '56.10.179.194', '2026-10-30 10:06:29', '2026-10-13 17:04:42', '', '2026-10-13 17:04:42', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (110, 103, 'testuser02', '测试用户02改', '00', '', '', '0', '', 'ed65d632bc4600b7f4e273fa1f72a62f', '5fe557', '0', '2', '', NULL, '2026-10-14 11:57:57', 'admin', '2026-10-14 11:57:57', 'admin', '2026-10-14 13:57:29', NULL);
INSERT INTO `sys_user` VALUES (111, NULL, '13900000001', '13900000001', '01', '', '13900000001', '0', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/30/avatar_20261030153752A017.jpg', '9dc511c637ca92e582593e6aabda5f33', '97751c', '0', '0', '39.144.231.36', '2026-11-18 16:27:18', '2026-10-27 14:19:20', '', '2026-10-14 15:45:53', '', '2026-10-30 15:37:55', NULL);
INSERT INTO `sys_user` VALUES (112, NULL, '13900139001', 'First', '01', '', '13900139001', '0', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/11/18/44a7a3e427204eefae8132160ba9e8f1_20261118164009A001.jpg', '349bb6d8622239a1438da865046f7b55', 'c283f6', '0', '0', '127.0.0.1', '2026-11-18 16:39:56', '2026-10-14 17:07:00', '', '2026-10-14 17:06:57', '', '2026-11-18 17:35:48', NULL);
INSERT INTO `sys_user` VALUES (113, NULL, '13900139002', '13900139002', '01', '', '13900139002', '0', '', '3ac2f99d5f3a3477588218b207bed117', '9ebc90', '0', '0', '127.0.0.1', '2026-10-16 14:42:25', '2026-10-16 14:42:08', '', '2026-10-16 14:42:09', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (114, NULL, '19885323438', '19885323438', '01', '', '19885323438', '0', '', '3c74f47c609987fd2a4c818a57c42833', 'ff76b4', '0', '0', '127.0.0.1', '2026-10-16 15:52:07', '2026-10-16 15:51:48', '', '2026-10-16 15:51:49', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (115, NULL, '13911112222', 'Ly', '01', '', '13911112222', '1', 'http://192.168.101.194:8081/profile/upload/2026/11/11/avatar_20261111155212A007.jpg', '411e7ca295bd45b25eb9a718fb6488f5', 'adaa18', '0', '0', '127.0.0.1', '2026-11-18 14:11:04', '2026-10-23 10:14:38', '', '2026-10-23 10:14:33', '', '2026-11-11 17:55:46', NULL);
INSERT INTO `sys_user` VALUES (116, NULL, '13888888888', '13888888888', '01', '', '13888888888', '0', NULL, 'dd4e030697fb73aac2a06b040550004b', 'e09f4a', '0', '0', '192.168.170.128', '2026-10-23 10:46:08', '2026-10-23 10:45:51', '', '2026-10-23 10:45:46', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (117, NULL, '13900001234', '13900001234', '01', '', '13900001234', '0', NULL, '3a1fdecff917b780186c67867bdad68c', '6bd387', '0', '0', '127.0.0.1', '2026-10-27 09:36:27', '2026-10-27 09:36:27', '', '2026-10-27 09:36:23', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (118, NULL, '13900000009', '13900000009', '01', '', '13900000009', '0', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/upload/2026/10/27/avatar_20261027220549A002.jpg', '48476381e1821574ea2ea79e0340acfe', 'da7065', '0', '0', '127.0.0.1', '2026-11-18 11:48:30', '2026-10-29 10:21:33', '', '2026-10-27 17:56:45', '', '2026-10-29 10:21:33', NULL);
INSERT INTO `sys_user` VALUES (119, NULL, '13911113333', '13911113333', '01', '', '13911113333', '0', NULL, '77fcc163da7c8ba001e781ad69faddb6', '321080', '0', '0', '192.168.88.1', '2026-11-09 10:59:40', '2026-10-28 23:51:57', '', '2026-10-28 23:51:55', '', '2026-10-29 00:43:00', NULL);
INSERT INTO `sys_user` VALUES (120, NULL, '13113131313', '13113131313', '01', '', '13113131313', '0', NULL, 'a8849d358a19facd7f804fbe0216937b', '0fc43b', '0', '0', '127.0.0.1', '2026-11-06 15:17:34', '2026-11-06 15:17:09', '', '2026-11-06 15:17:04', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (121, NULL, '13900009999', '13900009999', '01', '', '13900009999', '0', NULL, '31ad463b7386a3f09d1f7bcde1f13b9c', 'd3f137', '0', '0', '58.16.41.98', '2026-11-12 14:44:05', '2026-11-12 14:42:16', '', '2026-11-12 14:42:16', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (122, NULL, '18800001111', '18800001111', '01', '', '18800001111', '0', NULL, '54d592aa05c997234f0c48361ee13b87', 'd9ae8f', '0', '0', '58.16.41.98', '2026-11-18 11:37:21', '2026-11-16 09:06:38', '', '2026-11-16 09:06:34', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (123, NULL, '18785365694', '18785365694', '01', '', '18785365694', '0', NULL, 'e3d61fcac17e5e72667c3181871463a7', 'c55985', '0', '0', '127.0.0.1', '2026-11-17 14:44:09', '2026-11-17 14:37:02', '', '2026-11-17 14:37:03', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (124, NULL, '18785365695', '18785365695', '01', '', '18785365695', '0', NULL, 'aa1af076527065750c092029fe1cc1fc', 'f08f5f', '0', '0', '', NULL, '2026-11-17 14:43:50', '', '2026-11-17 14:43:50', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (125, NULL, '18785365696', '18785365696', '01', '', '18785365696', '0', NULL, 'fb7000deb8d02026fe0f79c45b47c6a4', '6f1c1d', '0', '0', '127.0.0.1', '2026-11-17 15:24:23', '2026-11-17 15:07:00', '', '2026-11-17 15:07:00', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (126, NULL, '13900149001', '13900149001', '01', '', '13900149001', '0', NULL, 'e1adf76abf6f031bfec3c5d55d0194b9', '1115f8', '0', '0', '127.0.0.1', '2026-11-17 15:09:41', '2026-11-17 15:09:16', '', '2026-11-17 15:09:10', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (127, NULL, '18785365697', '18785365697', '01', '', '18785365697', '0', NULL, 'b753178093b67b61badf67bdd0242123', '046e18', '0', '0', '', NULL, '2026-11-17 15:47:39', '', '2026-11-17 15:47:39', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (128, NULL, '13638010667', '13638010667', '01', '', '13638010667', '0', NULL, '1ac3fa685d9feca97446177f642f2c4e', 'f58ee0', '0', '0', '114.138.157.27', '2026-11-18 16:09:38', '2026-11-18 16:09:04', '', '2026-11-18 16:09:03', '', '2026-11-18 16:13:30', NULL);
INSERT INTO `sys_user` VALUES (129, NULL, '13339620617', '13339620617', '01', '', '13339620617', '0', NULL, '13488fab2d26ddc46a7d67c4d495dc61', '1f3262', '0', '0', '', NULL, '2026-11-18 16:22:34', '', '2026-11-18 16:22:34', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (130, NULL, '15585102712', '15585102712', '01', '', '15585102712', '0', NULL, 'bbd3b749ea8cc8cea8cb87c6d353dc31', 'ba88de', '0', '0', '', NULL, '2026-11-18 16:24:50', '', '2026-11-18 16:24:49', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_online
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_online`;
CREATE TABLE `sys_user_online`  (
  `sessionId` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户会话id',
  `login_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录账号',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '在线状态on_line在线off_line离线',
  `start_timestamp` datetime NULL DEFAULT NULL COMMENT 'session创建时间',
  `last_access_time` datetime NULL DEFAULT NULL COMMENT 'session最后访问时间',
  `expire_time` int NULL DEFAULT 0 COMMENT '超时时间，单位为分钟',
  `session_data` blob NULL COMMENT '序列化的Session数据，用于服务重启后恢复会话',
  PRIMARY KEY (`sessionId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '在线用户记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_online
-- ----------------------------
INSERT INTO `sys_user_online` VALUES ('3c5140db-cac2-4ed4-8f31-307ea3b3d090', 'admin', '研发部门', '127.0.0.1', '内网IP', 'Curl 8.22.0', '', 'on_line', '2026-11-19 09:21:51', '2026-11-19 09:21:52', 1800000, 0xACED00057372002B636F6D2E72756F79692E636F6D6D6F6E2E636F72652E73657373696F6E2E4F6E6C696E6553657373696F6E00000000000000010200084C00066176617461727400124C6A6176612F6C616E672F537472696E673B4C000762726F7773657271007E00014C0008646570744E616D6571007E00014C0004686F737471007E00014C00096C6F67696E4E616D6571007E00014C00026F7371007E00014C00067374617475737400254C636F6D2F72756F79692F636F6D6D6F6E2F656E756D732F4F6E6C696E655374617475733B4C00067573657249647400104C6A6176612F6C616E672F4C6F6E673B7872002A6F72672E6170616368652E736869726F2E73657373696F6E2E6D67742E53696D706C6553657373696F6E9D1CA1B8D58C626E03000078707702009B74002433633531343064622D636163322D346564342D386633312D3330376561336233643039307372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001A1F1655099787371007E00077708000001A1F16553C078770800000000001B7740737200266A6176612E7574696C2E636F6E63757272656E742E436F6E63757272656E74486173684D61706499DE129D87293D03000349000B7365676D656E744D61736B49000C7365676D656E7453686966745B00087365676D656E74737400315B4C6A6176612F7574696C2F636F6E63757272656E742F436F6E63757272656E74486173684D6170245365676D656E743B78700000000F0000001C757200315B4C6A6176612E7574696C2E636F6E63757272656E742E436F6E63757272656E74486173684D6170245365676D656E743B52773F41329B39740200007870000000107372002E6A6176612E7574696C2E636F6E63757272656E742E436F6E63757272656E74486173684D6170245365676D656E741F364C905893293D02000146000A6C6F6164466163746F72787200286A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E5265656E7472616E744C6F636B6655A82C2CC86AEB0200014C000473796E6374002F4C6A6176612F7574696C2F636F6E63757272656E742F6C6F636B732F5265656E7472616E744C6F636B2453796E633B7870737200346A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E5265656E7472616E744C6F636B244E6F6E6661697253796E63658832E7537BBF0B0200007872002D6A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E5265656E7472616E744C6F636B2453796E63B81EA294AA445A7C020000787200356A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E416273747261637451756575656453796E6368726F6E697A65726655A843753F52E30200014900057374617465787200366A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E41627374726163744F776E61626C6553796E6368726F6E697A657233DFAFB9AD6D6FA90200007870000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007400506F72672E6170616368652E736869726F2E7375626A6563742E737570706F72742E44656661756C745375626A656374436F6E746578745F41555448454E544943415445445F53455353494F4E5F4B4559737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787001740048636F6D2E72756F79692E6672616D65776F726B2E736869726F2E73657373696F6E2E4F6E6C696E6553657373696F6E44414F4C4153545F53594E435F44425F54494D455354414D5071007E000974004D6F72672E6170616368652E736869726F2E7375626A6563742E737570706F72742E44656661756C745375626A656374436F6E746578745F5052494E434950414C535F53455353494F4E5F4B4559737200356F72672E6170616368652E736869726F2E7375626A6563742E496D6D757461626C655072696E636970616C436F6C6C656374696F6E7057568687B455EC0200014C000F7265616C6D5072696E636970616C7374000F4C6A6176612F7574696C2F4D61703B7870737200226A6176612E7574696C2E436F6C6C656374696F6E732453696E676C65746F6E4D61709F230991717F6B910200024C00016B7400124C6A6176612F6C616E672F4F626A6563743B4C00017671007E003F787074002B636F6D2E72756F79692E6672616D65776F726B2E736869726F2E7265616C6D2E557365725265616C6D5F30737200116A6176612E7574696C2E436F6C6C536572578EABB63A1BA8110300014900037461677870000000027704000000017372002B636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E656E746974792E5379735573657200000000000000010200164C000661766174617271007E00014C000764656C466C616771007E00014C00046465707474002D4C636F6D2F72756F79692F636F6D6D6F6E2F636F72652F646F6D61696E2F656E746974792F537973446570743B4C000664657074496471007E00034C0005656D61696C71007E00014C00096C6F67696E446174657400104C6A6176612F7574696C2F446174653B4C00076C6F67696E497071007E00014C00096C6F67696E4E616D6571007E00014C0008706172656E74496471007E00034C000870617373776F726471007E00014C000B70686F6E656E756D62657271007E00015B0007706F73744964737400115B4C6A6176612F6C616E672F4C6F6E673B4C000D7077645570646174654461746571007E00464C0006726F6C65496471007E00035B0007726F6C6549647371007E00474C0005726F6C65737400104C6A6176612F7574696C2F4C6973743B4C000473616C7471007E00014C000373657871007E00014C000673746174757371007E00014C000675736572496471007E00034C0008757365724E616D6571007E00014C0008757365725479706571007E000178720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00014C000A63726561746554696D6571007E00464C0006706172616D7371007E003C4C000672656D61726B71007E00014C000B73656172636856616C756571007E00014C0008757064617465427971007E00014C000A75706461746554696D6571007E0046787074000561646D696E7371007E00077708000001A132C6C9B87870740009E7AEA1E79086E59198707400007071007E004E740001307372002B636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E656E746974792E53797344657074000000000000000102000C4C0009616E636573746F727371007E00014C000764656C466C616771007E00014C000664657074496471007E00034C0008646570744E616D6571007E00014C0005656D61696C71007E00014C00096578636C756465496471007E00034C00066C656164657271007E00014C00086F726465724E756D7400134C6A6176612F6C616E672F496E74656765723B4C0008706172656E74496471007E00034C000A706172656E744E616D6571007E00014C000570686F6E6571007E00014C000673746174757371007E00017871007E004970707070707070740009302C3130302C313031707372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000006774000CE7A094E58F91E983A8E997A87070740006E88BA5E4BE9D737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C75657871007E0055000000017371007E0054000000000000006570707400013071007E005674000A7279403136332E636F6D7371007E00077708000001A1ED53F5A87874000B35382E31362E34312E393874000561646D696E70740020323963363761333033393836333832363966653630306637336130353439333474000B313538383838383838383870707070737200136A6176612E7574696C2E41727261794C6973747881D21D99C7619D03000149000473697A657870000000017704000000017372002B636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E656E746974792E537973526F6C65000000000000000102000B5A0004666C61674C00096461746153636F706571007E00014C000764656C466C616771007E00015B00076465707449647371007E00475B00076D656E7549647371007E00474C000B7065726D697373696F6E7374000F4C6A6176612F7574696C2F5365743B4C0006726F6C65496471007E00034C0007726F6C654B657971007E00014C0008726F6C654E616D6571007E00014C0008726F6C65536F727471007E00014C000673746174757371007E00017871007E0049707070707070700074000131707070707371007E0054000000000000000174000561646D696E74000FE8B685E7BAA7E7AEA1E79086E59198740001317400013078740006313131313131740001317400013071007E0069740006E88BA5E4BE9D7400023030787070787871007E004E74000B4375726C20382E32322E3074000CE7A094E58F91E983A8E997A87400093132372E302E302E3174000561646D696E71007E004E7E720023636F6D2E72756F79692E636F6D6D6F6E2E656E756D732E4F6E6C696E6553746174757300000000000000001200007872000E6A6176612E6C616E672E456E756D000000000000000012000078707400076F6E5F6C696E657371007E00540000000000000001);
INSERT INTO `sys_user_online` VALUES ('4e1ffbe3-dd6c-4b56-8148-3cd4bd1cc12c', 'admin', '研发部门', '127.0.0.1', '内网IP', 'Edge 157', 'Windows >=10', 'on_line', '2026-11-19 09:23:28', '2026-11-19 09:24:20', 1800000, 0xACED00057372002B636F6D2E72756F79692E636F6D6D6F6E2E636F72652E73657373696F6E2E4F6E6C696E6553657373696F6E00000000000000010200084C00066176617461727400124C6A6176612F6C616E672F537472696E673B4C000762726F7773657271007E00014C0008646570744E616D6571007E00014C0004686F737471007E00014C00096C6F67696E4E616D6571007E00014C00026F7371007E00014C00067374617475737400254C636F6D2F72756F79692F636F6D6D6F6E2F656E756D732F4F6E6C696E655374617475733B4C00067573657249647400104C6A6176612F6C616E672F4C6F6E673B7872002A6F72672E6170616368652E736869726F2E73657373696F6E2E6D67742E53696D706C6553657373696F6E9D1CA1B8D58C626E03000078707702009B74002434653166666265332D646436632D346235362D383134382D3363643462643163633132637372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001A1F166CACD787371007E00077708000001A1F16796B478770800000000001B7740737200266A6176612E7574696C2E636F6E63757272656E742E436F6E63757272656E74486173684D61706499DE129D87293D03000349000B7365676D656E744D61736B49000C7365676D656E7453686966745B00087365676D656E74737400315B4C6A6176612F7574696C2F636F6E63757272656E742F436F6E63757272656E74486173684D6170245365676D656E743B78700000000F0000001C757200315B4C6A6176612E7574696C2E636F6E63757272656E742E436F6E63757272656E74486173684D6170245365676D656E743B52773F41329B39740200007870000000107372002E6A6176612E7574696C2E636F6E63757272656E742E436F6E63757272656E74486173684D6170245365676D656E741F364C905893293D02000146000A6C6F6164466163746F72787200286A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E5265656E7472616E744C6F636B6655A82C2CC86AEB0200014C000473796E6374002F4C6A6176612F7574696C2F636F6E63757272656E742F6C6F636B732F5265656E7472616E744C6F636B2453796E633B7870737200346A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E5265656E7472616E744C6F636B244E6F6E6661697253796E63658832E7537BBF0B0200007872002D6A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E5265656E7472616E744C6F636B2453796E63B81EA294AA445A7C020000787200356A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E416273747261637451756575656453796E6368726F6E697A65726655A843753F52E30200014900057374617465787200366A6176612E7574696C2E636F6E63757272656E742E6C6F636B732E41627374726163744F776E61626C6553796E6368726F6E697A657233DFAFB9AD6D6FA90200007870000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007371007E000F7371007E0013000000003F4000007400506F72672E6170616368652E736869726F2E7375626A6563742E737570706F72742E44656661756C745375626A656374436F6E746578745F41555448454E544943415445445F53455353494F4E5F4B4559737200116A6176612E6C616E672E426F6F6C65616ECD207280D59CFAEE0200015A000576616C7565787001740048636F6D2E72756F79692E6672616D65776F726B2E736869726F2E73657373696F6E2E4F6E6C696E6553657373696F6E44414F4C4153545F53594E435F44425F54494D455354414D5071007E000974004D6F72672E6170616368652E736869726F2E7375626A6563742E737570706F72742E44656661756C745375626A656374436F6E746578745F5052494E434950414C535F53455353494F4E5F4B4559737200356F72672E6170616368652E736869726F2E7375626A6563742E496D6D757461626C655072696E636970616C436F6C6C656374696F6E7057568687B455EC0200014C000F7265616C6D5072696E636970616C7374000F4C6A6176612F7574696C2F4D61703B7870737200226A6176612E7574696C2E436F6C6C656374696F6E732453696E676C65746F6E4D61709F230991717F6B910200024C00016B7400124C6A6176612F6C616E672F4F626A6563743B4C00017671007E003F787074002B636F6D2E72756F79692E6672616D65776F726B2E736869726F2E7265616C6D2E557365725265616C6D5F30737200116A6176612E7574696C2E436F6C6C536572578EABB63A1BA8110300014900037461677870000000027704000000017372002B636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E656E746974792E5379735573657200000000000000010200164C000661766174617271007E00014C000764656C466C616771007E00014C00046465707474002D4C636F6D2F72756F79692F636F6D6D6F6E2F636F72652F646F6D61696E2F656E746974792F537973446570743B4C000664657074496471007E00034C0005656D61696C71007E00014C00096C6F67696E446174657400104C6A6176612F7574696C2F446174653B4C00076C6F67696E497071007E00014C00096C6F67696E4E616D6571007E00014C0008706172656E74496471007E00034C000870617373776F726471007E00014C000B70686F6E656E756D62657271007E00015B0007706F73744964737400115B4C6A6176612F6C616E672F4C6F6E673B4C000D7077645570646174654461746571007E00464C0006726F6C65496471007E00035B0007726F6C6549647371007E00474C0005726F6C65737400104C6A6176612F7574696C2F4C6973743B4C000473616C7471007E00014C000373657871007E00014C000673746174757371007E00014C000675736572496471007E00034C0008757365724E616D6571007E00014C0008757365725479706571007E000178720027636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00014C000A63726561746554696D6571007E00464C0006706172616D7371007E003C4C000672656D61726B71007E00014C000B73656172636856616C756571007E00014C0008757064617465427971007E00014C000A75706461746554696D6571007E0046787074000561646D696E7371007E00077708000001A132C6C9B87870740009E7AEA1E79086E59198707400007071007E004E740001307372002B636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E656E746974792E53797344657074000000000000000102000C4C0009616E636573746F727371007E00014C000764656C466C616771007E00014C000664657074496471007E00034C0008646570744E616D6571007E00014C0005656D61696C71007E00014C00096578636C756465496471007E00034C00066C656164657271007E00014C00086F726465724E756D7400134C6A6176612F6C616E672F496E74656765723B4C0008706172656E74496471007E00034C000A706172656E744E616D6571007E00014C000570686F6E6571007E00014C000673746174757371007E00017871007E004970707070707070740009302C3130302C313031707372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000000000006774000CE7A094E58F91E983A8E997A87070740006E88BA5E4BE9D737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C75657871007E0055000000017371007E0054000000000000006570707400013071007E005674000A7279403136332E636F6D7371007E00077708000001A1F1654F98787400093132372E302E302E3174000561646D696E70740020323963363761333033393836333832363966653630306637336130353439333474000B313538383838383838383870707070737200136A6176612E7574696C2E41727261794C6973747881D21D99C7619D03000149000473697A657870000000017704000000017372002B636F6D2E72756F79692E636F6D6D6F6E2E636F72652E646F6D61696E2E656E746974792E537973526F6C65000000000000000102000B5A0004666C61674C00096461746153636F706571007E00014C000764656C466C616771007E00015B00076465707449647371007E00475B00076D656E7549647371007E00474C000B7065726D697373696F6E7374000F4C6A6176612F7574696C2F5365743B4C0006726F6C65496471007E00034C0007726F6C654B657971007E00014C0008726F6C654E616D6571007E00014C0008726F6C65536F727471007E00014C000673746174757371007E00017871007E0049707070707070700074000131707070707371007E0054000000000000000174000561646D696E74000FE8B685E7BAA7E7AEA1E79086E59198740001317400013078740006313131313131740001317400013071007E0069740006E88BA5E4BE9D74000230307874000A637372665F746F6B656E74002C4E58784B52316451453839665550536D58395A3673417A6836447765653767374E785861536551597255673D7070787871007E004E740008456467652031353774000CE7A094E58F91E983A8E997A87400093132372E302E302E3174000561646D696E74000C57696E646F7773203E3D31307E720023636F6D2E72756F79692E636F6D6D6F6E2E656E756D732E4F6E6C696E6553746174757300000000000000001200007872000E6A6176612E6C616E672E456E756D000000000000000012000078707400076F6E5F6C696E657371007E00540000000000000001);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (104, 1);
INSERT INTO `sys_user_role` VALUES (106, 2);
INSERT INTO `sys_user_role` VALUES (107, 2);
INSERT INTO `sys_user_role` VALUES (108, 2);
INSERT INTO `sys_user_role` VALUES (109, 2);
INSERT INTO `sys_user_role` VALUES (111, 2);
INSERT INTO `sys_user_role` VALUES (112, 2);
INSERT INTO `sys_user_role` VALUES (113, 2);
INSERT INTO `sys_user_role` VALUES (114, 2);
INSERT INTO `sys_user_role` VALUES (115, 2);
INSERT INTO `sys_user_role` VALUES (116, 2);
INSERT INTO `sys_user_role` VALUES (117, 2);
INSERT INTO `sys_user_role` VALUES (118, 2);
INSERT INTO `sys_user_role` VALUES (119, 2);
INSERT INTO `sys_user_role` VALUES (120, 2);
INSERT INTO `sys_user_role` VALUES (121, 2);
INSERT INTO `sys_user_role` VALUES (122, 2);
INSERT INTO `sys_user_role` VALUES (123, 2);
INSERT INTO `sys_user_role` VALUES (124, 2);
INSERT INTO `sys_user_role` VALUES (125, 2);
INSERT INTO `sys_user_role` VALUES (126, 2);
INSERT INTO `sys_user_role` VALUES (127, 2);
INSERT INTO `sys_user_role` VALUES (128, 2);
INSERT INTO `sys_user_role` VALUES (129, 2);
INSERT INTO `sys_user_role` VALUES (130, 2);

SET FOREIGN_KEY_CHECKS = 1;
