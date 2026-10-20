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

 Date: 20/10/2026 14:31:29
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
) ENGINE = InnoDB AUTO_INCREMENT = 146 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台API访问令牌表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_api_token
-- ----------------------------
INSERT INTO `learning_api_token` VALUES (107, '985ffb85c95548a99fd455b315f788ec', 106, '58.16.41.98', '2026-11-14 16:01:43', '2026-10-15 16:01:43');
INSERT INTO `learning_api_token` VALUES (108, '4d35d9a1837c4b46b4fc12e025b73547', 106, '58.16.41.98', '2026-11-14 16:06:22', '2026-10-15 16:06:22');
INSERT INTO `learning_api_token` VALUES (109, 'e97abcfa7f744bbf81b5fd51ca09450c', 106, '58.16.41.98', '2026-11-14 17:29:06', '2026-10-15 17:29:06');
INSERT INTO `learning_api_token` VALUES (110, 'b98248d8a2ac48b8be64ffd802038f10', 112, '220.197.4.211', '2026-11-14 17:37:10', '2026-10-15 17:37:10');
INSERT INTO `learning_api_token` VALUES (111, 'af6b19476b3d47fe95e409cf7335e999', 112, '220.197.4.211', '2026-11-14 17:38:35', '2026-10-15 17:38:35');
INSERT INTO `learning_api_token` VALUES (112, '9a3b51d3d1b248c1bddb414074423c4d', 112, '220.197.4.211', '2026-11-14 17:39:24', '2026-10-15 17:39:24');
INSERT INTO `learning_api_token` VALUES (113, '73ac6d58ffd64ff2b91cfdbcb58577d1', 112, '127.0.0.1', '2026-11-15 14:41:05', '2026-10-16 14:41:05');
INSERT INTO `learning_api_token` VALUES (115, '34e61e5d711e471c9718acc7db6f5095', 112, '127.0.0.1', '2026-11-15 15:04:54', '2026-10-16 15:04:54');
INSERT INTO `learning_api_token` VALUES (116, '3dd2197bc3934bc8ac6a5476b57cd32b', 112, '127.0.0.1', '2026-11-15 15:30:56', '2026-10-16 15:30:56');
INSERT INTO `learning_api_token` VALUES (117, '5e7a1e80b51b427e91c3b0773b4237ae', 114, '127.0.0.1', '2026-11-15 15:52:07', '2026-10-16 15:52:07');
INSERT INTO `learning_api_token` VALUES (118, '7010503a0b194c8dbe445dffc7c10fe9', 112, '127.0.0.1', '2026-11-15 16:50:31', '2026-10-16 16:50:31');
INSERT INTO `learning_api_token` VALUES (119, 'a6bf5ba1faf549dda302811161c1948e', 112, '127.0.0.1', '2026-11-15 16:52:37', '2026-10-16 16:52:37');
INSERT INTO `learning_api_token` VALUES (120, 'b06c1923d4eb49c0b0d266e8e2fff3ac', 111, '127.0.0.1', '2026-11-18 10:22:07', '2026-10-19 10:22:07');
INSERT INTO `learning_api_token` VALUES (121, 'c968b657d7904e959ce1e0d175221547', 111, '127.0.0.1', '2026-11-18 10:22:44', '2026-10-19 10:22:44');
INSERT INTO `learning_api_token` VALUES (122, '680713d0ace1413ab0d3aa0d2a771c0a', 111, '127.0.0.1', '2026-11-18 10:23:00', '2026-10-19 10:23:00');
INSERT INTO `learning_api_token` VALUES (123, 'e24eabd840d44560b184af4b81fd4a17', 111, '127.0.0.1', '2026-11-18 10:23:16', '2026-10-19 10:23:16');
INSERT INTO `learning_api_token` VALUES (124, '449a8c8dd9524da2befd1fcf307c619a', 111, '127.0.0.1', '2026-11-18 10:23:33', '2026-10-19 10:23:33');
INSERT INTO `learning_api_token` VALUES (125, '2dc76dcb68f448afb346cd0d3c937253', 111, '127.0.0.1', '2026-11-18 10:23:47', '2026-10-19 10:23:47');
INSERT INTO `learning_api_token` VALUES (126, '4330979197cf4e6698f336e9bb76d206', 111, '127.0.0.1', '2026-11-18 10:50:46', '2026-10-19 10:50:46');
INSERT INTO `learning_api_token` VALUES (127, '3a44fbeb5a3748e58d841ee64bcc5eb6', 111, '58.16.41.98', '2026-11-18 11:32:16', '2026-10-19 11:32:16');
INSERT INTO `learning_api_token` VALUES (128, '2388cfc1fd1a4bcd8bc7837e6f1fb431', 111, '58.16.41.98', '2026-11-18 11:32:40', '2026-10-19 11:32:40');
INSERT INTO `learning_api_token` VALUES (129, '729b1fbb8e55419ab92d3dd9078fd764', 106, '58.16.41.98', '2026-11-18 11:41:50', '2026-10-19 11:41:50');
INSERT INTO `learning_api_token` VALUES (130, '38d6c3bd481f4fd4b77f3829dea06e6b', 111, '127.0.0.1', '2026-11-18 11:57:14', '2026-10-19 11:57:14');
INSERT INTO `learning_api_token` VALUES (131, '4269a97320f74887b1fcc22722616a1a', 111, '127.0.0.1', '2026-11-18 14:38:27', '2026-10-19 14:38:27');
INSERT INTO `learning_api_token` VALUES (132, 'eec52e3ed3714251a477828e0417fc89', 111, '127.0.0.1', '2026-11-18 14:38:42', '2026-10-19 14:38:42');
INSERT INTO `learning_api_token` VALUES (133, 'f7357772cdc3439bb66dc3ae8595b209', 111, '127.0.0.1', '2026-11-18 14:47:36', '2026-10-19 14:47:36');
INSERT INTO `learning_api_token` VALUES (134, '90d0b66a6e964df0a53d4511933e49be', 111, '127.0.0.1', '2026-11-18 14:47:47', '2026-10-19 14:47:47');
INSERT INTO `learning_api_token` VALUES (135, 'bed70e4af36942bdbe15352a0faeea1c', 111, '127.0.0.1', '2026-11-18 14:49:45', '2026-10-19 14:49:45');
INSERT INTO `learning_api_token` VALUES (136, 'e2594cbec5674249bd9c848cff4fff0f', 111, '127.0.0.1', '2026-11-18 14:52:58', '2026-10-19 14:52:58');
INSERT INTO `learning_api_token` VALUES (137, 'c11f268bd0ae413fad1054604925ecb6', 111, '47.128.243.133', '2026-11-18 16:47:10', '2026-10-19 16:47:10');
INSERT INTO `learning_api_token` VALUES (138, '89958369598b4843b6a26a6dfe40e057', 112, '127.0.0.1', '2026-11-19 12:51:34', '2026-10-20 12:51:34');
INSERT INTO `learning_api_token` VALUES (139, '0037477f72674f87a85fd9545b4552f8', 112, '127.0.0.1', '2026-11-19 12:52:41', '2026-10-20 12:52:41');
INSERT INTO `learning_api_token` VALUES (140, '3abada0c0bba465a8b9f348bb58a2126', 112, '127.0.0.1', '2026-11-19 13:18:00', '2026-10-20 13:18:00');
INSERT INTO `learning_api_token` VALUES (141, '4d5a260b2cd44ba385626472ac4b6d9f', 112, '127.0.0.1', '2026-11-19 14:13:36', '2026-10-20 14:13:36');
INSERT INTO `learning_api_token` VALUES (142, '6b7f8e881d924b9587fe7d9a503839fd', 112, '127.0.0.1', '2026-11-19 14:20:21', '2026-10-20 14:20:21');
INSERT INTO `learning_api_token` VALUES (143, 'ac9eed92b8b243c0aacc4693e9281a07', 112, '127.0.0.1', '2026-11-19 14:27:26', '2026-10-20 14:27:26');
INSERT INTO `learning_api_token` VALUES (144, 'fbc67482ac0041318e84edea2d182fed', 112, '127.0.0.1', '2026-11-19 14:27:52', '2026-10-20 14:27:52');
INSERT INTO `learning_api_token` VALUES (145, '6392b1a44f454328a97621c3dc09e62b', 112, '127.0.0.1', '2026-11-19 14:28:32', '2026-10-20 14:28:32');

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
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台课程轮播图表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_banner
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '签到记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_checkin
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_comment
-- ----------------------------
INSERT INTO `learning_comment` VALUES (100, 106, '1', 101, NULL, NULL, '评论测试一级', '2', '2026-10-15 17:37:25', '2026-10-15 17:39:02');
INSERT INTO `learning_comment` VALUES (101, 106, '1', 101, 100, 106, '评论测试二级回复', '2', '2026-10-15 17:37:50', '2026-10-15 17:39:02');
INSERT INTO `learning_comment` VALUES (102, 112, '3', 100, NULL, NULL, 'hhh', '0', '2026-10-16 17:27:43', NULL);

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
  PRIMARY KEY (`course_id`) USING BTREE,
  INDEX `idx_course_category`(`category_id` ASC, `del_flag` ASC) USING BTREE,
  CONSTRAINT `chk_course_favorite_count` CHECK (`favorite_count` >= 0),
  CONSTRAINT `chk_course_like_count` CHECK (`like_count` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 204 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_course
-- ----------------------------
INSERT INTO `learning_course` VALUES (100, '大数据', 101, '/profile/upload/2026/10/13/曾俊杰-贵州大学_20261013154048A001.png', '把啊', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-13 15:41:00', '', '2026-10-13 15:41:29', '无');
INSERT INTO `learning_course` VALUES (101, '测试课程A改', 101, '', '自动化测试', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-14 09:50:50', 'admin', '2026-10-14 11:39:19', NULL);
INSERT INTO `learning_course` VALUES (102, '搜索测试课程', 101, '', '搜索测试', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 16:09:30', '', '2026-10-15 16:12:39', NULL);
INSERT INTO `learning_course` VALUES (103, '分类测试课程A', 101, '', '测试', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 17:29:16', '', '2026-10-15 17:56:11', NULL);
INSERT INTO `learning_course` VALUES (104, '分类测试课程B', 101, '', '测试', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 17:29:21', '', '2026-10-15 17:56:11', NULL);
INSERT INTO `learning_course` VALUES (105, '分类测试课程C', 101, '', '测试', 0, 0, 0, 0, 0, '1', '2', 'admin', '2026-10-15 17:29:40', 'admin', '2026-10-15 17:56:11', NULL);
INSERT INTO `learning_course` VALUES (107, '评分回归课程', 101, '', '回归', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-16 14:49:25', '', '2026-10-16 14:50:14', NULL);
INSERT INTO `learning_course` VALUES (112, '笔记测试课程(可删)', NULL, '', '', 0, 0, 0, 0, 0, '0', '0', '', '2026-10-19 10:50:39', '', NULL, NULL);
INSERT INTO `learning_course` VALUES (201, 'Java 从入门到实战', 101, NULL, '面向初学者的 Java 系统课程：环境搭建、语法基础、面向对象与集合框架', 0, 0, 0, 0, 0, '0', '0', 'admin', '2026-10-20 14:20:43', '', NULL, '测试数据-前端调试');
INSERT INTO `learning_course` VALUES (202, 'MySQL 性能优化实战', 103, NULL, '从索引原理到执行计划，实战排查慢查询与 SQL 优化', 0, 0, 0, 0, 0, '0', '0', 'admin', '2026-10-20 14:20:43', '', NULL, '测试数据-前端调试');
INSERT INTO `learning_course` VALUES (203, 'Redis 缓存原理与实战', 105, NULL, 'Redis 数据类型、持久化与缓存穿透/击穿/雪崩解决方案', 0, 0, 0, 0, 0, '0', '0', 'admin', '2026-10-20 14:20:43', '', NULL, '测试数据-前端调试');

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
  PRIMARY KEY (`rating_id`) USING BTREE,
  UNIQUE INDEX `uk_course_user`(`course_id` ASC, `user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台课程评分表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_course_rating
-- ----------------------------

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
  PRIMARY KEY (`video_id`) USING BTREE,
  INDEX `idx_video_course`(`course_id` ASC, `del_flag` ASC) USING BTREE,
  INDEX `idx_video_chapter`(`chapter_id` ASC, `del_flag` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 207 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台课程视频表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_course_video
-- ----------------------------
INSERT INTO `learning_course_video` VALUES (100, 101, NULL, '第一课视频改', 'http://example.com/v2.mp4', 1, '2', 'admin', '2026-10-14 11:36:47', 'admin', '2026-10-14 11:39:19');
INSERT INTO `learning_course_video` VALUES (105, 112, NULL, '笔记测试小节(可删)', '/profile/upload/test.mp4', 1, '0', '', '2026-10-19 10:50:39', '', NULL);
INSERT INTO `learning_course_video` VALUES (201, 201, 201, '01-环境搭建与第一个程序', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/java-intro.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL);
INSERT INTO `learning_course_video` VALUES (202, 201, 202, '02-面向对象核心概念', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/java-intro.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL);
INSERT INTO `learning_course_video` VALUES (203, 202, 203, '01-索引原理与 EXPLAIN', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/mysql-optimize.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL);
INSERT INTO `learning_course_video` VALUES (204, 202, 204, '02-慢 SQL 实战调优', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/mysql-optimize.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL);
INSERT INTO `learning_course_video` VALUES (205, 203, 205, '01-Redis 数据类型精讲', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/redis-cache.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL);
INSERT INTO `learning_course_video` VALUES (206, 203, 206, '02-缓存三兄弟解决方案', 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/course/redis-cache.mp4', 1, '0', 'admin', '2026-10-20 14:21:08', '', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台用户关注表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_follow
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 146 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台点赞收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_interaction
-- ----------------------------
INSERT INTO `learning_interaction` VALUES (102, 104, '3', 100, '2', '2026-10-14 15:19:17');

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户笔记（课程小节 / 帖子）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_note
-- ----------------------------
INSERT INTO `learning_note` VALUES (6, 111, 'video', 105, '自检', 'ok', 88, '2', '2026-10-19 10:50:46', '2026-10-19 10:50:47');
INSERT INTO `learning_note` VALUES (7, 111, 'post', 101, '文章笔记测试', '这是一条文章笔记正文', NULL, '2', '2026-10-19 11:32:57', '2026-10-19 11:35:52');
INSERT INTO `learning_note` VALUES (8, 111, 'video', 105, '视频笔记改', '改后正文', 1250, '2', '2026-10-19 11:33:12', '2026-10-19 11:51:50');
INSERT INTO `learning_note` VALUES (9, 111, 'post', 101, '来源删除后仍可编辑', 'ok', NULL, '2', '2026-10-19 11:44:11', '2026-10-19 11:55:44');
INSERT INTO `learning_note` VALUES (10, 111, 'post', 101, 'JSON提交测试改', 'json edit', NULL, '2', '2026-10-19 11:50:34', '2026-10-19 11:51:20');

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
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '评论摘要（仅评论类有值，与 learning_comment.content 一致）',
  `is_read` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '读取状态（0未读 1已读）',
  `read_time` datetime NULL DEFAULT NULL COMMENT '读取时间（未读为NULL）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '产生时间',
  PRIMARY KEY (`notification_id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_user_read_time`(`user_id` ASC, `is_read` ASC, `create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台用户通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_notification
-- ----------------------------
INSERT INTO `learning_notification` VALUES (100, 1, 106, '3', '1', 101, '评论测试一级', '0', NULL, '2026-10-15 17:37:25');
INSERT INTO `learning_notification` VALUES (101, 1, 106, '3', '1', 101, '评论测试二级回复', '0', NULL, '2026-10-15 17:37:50');
INSERT INTO `learning_notification` VALUES (102, 104, 106, '4', NULL, NULL, NULL, '0', NULL, '2026-10-15 17:53:56');
INSERT INTO `learning_notification` VALUES (103, 1, 106, '4', NULL, NULL, NULL, '0', NULL, '2026-10-15 17:54:13');
INSERT INTO `learning_notification` VALUES (104, 104, 106, '1', '3', 100, NULL, '0', NULL, '2026-10-15 17:55:55');
INSERT INTO `learning_notification` VALUES (105, 104, 111, '1', '3', 100, NULL, '0', NULL, '2026-10-16 14:15:56');
INSERT INTO `learning_notification` VALUES (106, 104, 112, '1', '3', 100, NULL, '0', NULL, '2026-10-16 16:58:18');
INSERT INTO `learning_notification` VALUES (107, 104, 112, '1', '3', 100, NULL, '0', NULL, '2026-10-16 16:58:19');
INSERT INTO `learning_notification` VALUES (108, 104, 112, '1', '3', 100, NULL, '0', NULL, '2026-10-16 16:58:20');
INSERT INTO `learning_notification` VALUES (109, 104, 112, '2', '3', 100, NULL, '0', NULL, '2026-10-16 16:58:27');
INSERT INTO `learning_notification` VALUES (110, 104, 112, '1', '3', 100, NULL, '0', NULL, '2026-10-16 16:58:47');
INSERT INTO `learning_notification` VALUES (111, 104, 112, '3', '3', 100, 'hhh', '0', NULL, '2026-10-16 17:27:43');
INSERT INTO `learning_notification` VALUES (112, 111, 112, '2', '3', 203, NULL, '0', NULL, '2026-10-20 14:29:59');

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
INSERT INTO `learning_points_account` VALUES (112, 0, 0, NULL, '2026-10-20 14:27:05', '2026-10-20 14:27:05');

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
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_points_log
-- ----------------------------

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
  PRIMARY KEY (`post_id`) USING BTREE,
  INDEX `idx_post_category`(`category_id` ASC, `del_flag` ASC) USING BTREE,
  INDEX `idx_post_user`(`user_id` ASC, `del_flag` ASC) USING BTREE,
  INDEX `idx_post_status`(`status` ASC, `del_flag` ASC) USING BTREE,
  CONSTRAINT `chk_post_favorite_count` CHECK (`favorite_count` >= 0),
  CONSTRAINT `chk_post_like_count` CHECK (`like_count` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 206 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台社区帖子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_post
-- ----------------------------
INSERT INTO `learning_post` VALUES (100, '回归测试帖', 100, 106, '测试内容', 0, 0, 0, '0', '0', '2', '13900001111', '2026-10-14 11:27:41', '', '2026-10-14 11:29:19', NULL, NULL);
INSERT INTO `learning_post` VALUES (101, '管理员的帖子改', 100, 1, '改后内容', 0, 0, 0, '0', '0', '0', 'admin', '2026-10-14 11:43:20', 'admin', '2026-10-19 14:08:42', NULL, NULL);
INSERT INTO `learning_post` VALUES (102, '管理员的草稿', 100, 1, '', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-14 11:43:25', '', '2026-10-14 11:45:16', NULL, NULL);
INSERT INTO `learning_post` VALUES (103, '139的帖子改', 100, 106, '我改的', 0, 0, 0, '0', '0', '2', '13900001111', '2026-10-14 11:49:50', '13900001111', '2026-10-14 11:52:27', NULL, NULL);
INSERT INTO `learning_post` VALUES (106, '边界草稿', 100, 1, '', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-15 11:23:27', '', '2026-10-15 11:27:30', NULL, NULL);
INSERT INTO `learning_post` VALUES (108, '搜索测试帖', 100, 1, '搜索测试内容', 0, 0, 0, '0', '0', '2', 'admin', '2026-10-15 16:09:17', '', '2026-10-15 16:12:34', NULL, NULL);
INSERT INTO `learning_post` VALUES (109, '搜索草稿帖', 100, 1, '', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-15 16:09:22', '', '2026-10-15 17:56:05', NULL, NULL);
INSERT INTO `learning_post` VALUES (110, '审核测试帖', 100, 106, '审核测试内容', 0, 0, 0, '0', '1', '2', '13900001111', '2026-10-15 17:39:34', 'admin', '2026-10-15 17:56:05', NULL, '内容合格通过');
INSERT INTO `learning_post` VALUES (111, '审核驳回帖', 100, 106, '驳回测试内容', 0, 0, 0, '4', '0', '2', '13900001111', '2026-10-15 17:50:01', 'admin', '2026-10-15 17:56:05', NULL, '内容不合规');
INSERT INTO `learning_post` VALUES (113, '提示语回归草稿', 100, 1, '草稿', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-16 14:51:01', '', '2026-10-16 15:04:43', NULL, NULL);
INSERT INTO `learning_post` VALUES (119, '笔记草稿测试', 100, 1, '草稿', 0, 0, 0, '1', '0', '2', 'admin', '2026-10-19 11:38:36', '', '2026-10-19 11:51:57', NULL, NULL);
INSERT INTO `learning_post` VALUES (201, 'Java 8 Stream 流式编程实践', 100, 111, 'Stream API 的核心用法：filter/map/collect 链式操作、并行流注意事项与常见坑位，让集合处理更简洁高效。', 0, 0, 0, '0', '0', '0', '111', '2026-10-20 14:21:20', '', NULL, NULL, NULL);
INSERT INTO `learning_post` VALUES (202, 'MySQL 索引失效的常见场景', 102, 111, '函数运算、隐式类型转换、前导模糊查询、OR 连接等导致索引失效的典型场景，以及对应的规避写法。', 0, 0, 0, '0', '0', '0', '111', '2026-10-20 14:21:20', '', NULL, NULL, NULL);
INSERT INTO `learning_post` VALUES (203, 'Redis 缓存穿透、击穿与雪崩', 104, 111, '三种缓存异常的成因图解：空值缓存、布隆过滤器、互斥锁与逻辑过期等经典解决方案。', 0, 0, 0, '0', '0', '0', '111', '2026-10-20 14:21:20', '', NULL, NULL, NULL);
INSERT INTO `learning_post` VALUES (204, 'Kafka 消息可靠性保障机制', 106, 111, '生产端 ACK 机制、消费端手动提交、幂等生产者与事务消息，保障消息不丢不重的实践总结。', 0, 0, 0, '0', '0', '0', '111', '2026-10-20 14:21:20', '', NULL, NULL, NULL);
INSERT INTO `learning_post` VALUES (205, '从单体到微服务的架构演进', 108, 111, '服务拆分原则、注册中心选型、网关与配置中心，以及微服务化过程中的常见踩坑记录。', 0, 0, 0, '0', '0', '0', '111', '2026-10-20 14:21:20', '', NULL, NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 204 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习平台短视频表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_short_video
-- ----------------------------
INSERT INTO `learning_short_video` VALUES (100, '212312321', 104, '/profile/upload/2026/10/14/反恐精英：全球攻势 2024-12-06 20-06-30_20261014141955A002.mp4', '/profile/upload/2026/10/14/Capture001_20261014141953A001.png', 'wqqwe', 301, 0, 0, 1, 1, '0', '0', 'eduadmin', '2026-10-14 14:20:12', 'eduadmin', '2026-10-14 14:30:48', '');
INSERT INTO `learning_short_video` VALUES (103, '测试短视频A改', 1, '/profile/upload/2026/10/15/test.mp4', '', '自动化测试', 30, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 10:55:47', 'admin', '2026-10-15 10:59:52', NULL);
INSERT INTO `learning_short_video` VALUES (104, '搜索测试A', 1, '/profile/upload/2026/10/15/sa.mp4', '', '', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 16:09:05', '', '2026-10-15 16:12:30', NULL);
INSERT INTO `learning_short_video` VALUES (105, '搜索测试B', 1, '/profile/upload/2026/10/15/sb.mp4', '', '', 0, 0, 0, 0, 0, '1', '2', 'admin', '2026-10-15 16:09:11', 'admin', '2026-10-15 16:12:30', NULL);
INSERT INTO `learning_short_video` VALUES (106, '孤儿回归', 1, '/profile/upload/2026/10/15/reg.mp4', '', '', 0, 0, 0, 0, 0, '0', '2', 'admin', '2026-10-15 17:26:06', '', '2026-10-15 17:26:34', NULL);
INSERT INTO `learning_short_video` VALUES (201, 'Sintel 开源短片 · 片段一', 111, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-1.mp4', NULL, '开源动画短片 Sintel 精彩片段', 52, 0, 0, 0, 0, '0', '0', '111', '2026-10-20 14:21:29', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (202, 'Sintel 开源短片 · 片段二', 111, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-2.mp4', NULL, '开源动画短片 Sintel 精彩片段', 52, 0, 0, 0, 0, '0', '0', '111', '2026-10-20 14:21:29', '', NULL, NULL);
INSERT INTO `learning_short_video` VALUES (203, 'Sintel 开源短片 · 片段三', 111, 'https://zhinengguanggaopingtai.oss-cn-shanghai.aliyuncs.com/edu/short/short-3.mp4', NULL, '开源动画短片 Sintel 精彩片段', 52, 0, 0, 0, 0, '0', '0', '111', '2026-10-20 14:21:29', '', NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-10-13 09:00:52', '', NULL, '性别未知');
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
) ENGINE = InnoDB AUTO_INCREMENT = 294 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2065 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 260 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

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
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '头像路径',
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
) ENGINE = InnoDB AUTO_INCREMENT = 115 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '29c67a30398638269fe600f73a054934', '111111', '0', '0', '58.16.41.98', '2026-10-19 14:08:32', NULL, 'admin', '2026-10-13 09:00:51', '', NULL, '管理员');
INSERT INTO `sys_user` VALUES (104, 103, 'eduadmin', '平台管理员', '00', 'eduadmin@qq.com', '13800000000', '0', '', 'b7c399189dc25b1f4b61243c6c401997', '30c671', '0', '0', '127.0.0.1', '2026-10-14 16:27:21', '2026-10-14 14:16:39', 'admin', '2026-10-13 11:25:49', '', '2026-10-14 14:16:39', '平台管理员账号');
INSERT INTO `sys_user` VALUES (106, NULL, '13900001111', '13900001111', '01', '', '13900001111', '0', '', '1c3a3325d5951de1ea6648c6854d67a0', 'af4b7a', '0', '0', '58.16.41.98', '2026-10-19 14:09:13', '2026-10-13 15:04:08', '', '2026-10-13 15:04:07', '', '2026-10-14 14:01:19', NULL);
INSERT INTO `sys_user` VALUES (107, NULL, '18085885945', '18085885945', '01', '', '18085885945', '0', '', 'ad563769c7626e452287599a4de61ff3', '839e82', '0', '0', '', NULL, '2026-10-13 15:51:33', '', '2026-10-13 15:51:32', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (108, NULL, '19000000001', '19000000001', '01', '', '19000000001', '0', '', '81054861b6f7e8117d7c498993bd4619', '344e5a', '0', '0', '', NULL, '2026-10-13 16:30:27', '', '2026-10-13 16:30:27', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (109, NULL, '13900007777', '13900007777', '01', '', '13900007777', '0', '', '709d9e7ec87780d9e935ff2f7e9ff034', '47e27a', '0', '0', '', NULL, '2026-10-13 17:04:42', '', '2026-10-13 17:04:42', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (110, 103, 'testuser02', '测试用户02改', '00', '', '', '0', '', 'ed65d632bc4600b7f4e273fa1f72a62f', '5fe557', '0', '2', '', NULL, '2026-10-14 11:57:57', 'admin', '2026-10-14 11:57:57', 'admin', '2026-10-14 13:57:29', NULL);
INSERT INTO `sys_user` VALUES (111, NULL, '13900000001', '13900000001', '01', '', '13900000001', '0', '', '432143ab57896cf55801a8452d353103', '2aaaa2', '0', '0', '47.128.243.133', '2026-10-19 16:47:10', '2026-10-14 15:45:53', '', '2026-10-14 15:45:53', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (112, NULL, '13900139001', '13900139001', '01', '', '13900139001', '0', '', '349bb6d8622239a1438da865046f7b55', 'c283f6', '0', '0', '127.0.0.1', '2026-10-20 14:28:32', '2026-10-14 17:07:00', '', '2026-10-14 17:06:57', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (113, NULL, '13900139002', '13900139002', '01', '', '13900139002', '0', '', '3ac2f99d5f3a3477588218b207bed117', '9ebc90', '0', '0', '127.0.0.1', '2026-10-16 14:42:25', '2026-10-16 14:42:08', '', '2026-10-16 14:42:09', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (114, NULL, '19885323438', '19885323438', '01', '', '19885323438', '0', '', '3c74f47c609987fd2a4c818a57c42833', 'ff76b4', '0', '0', '127.0.0.1', '2026-10-16 15:52:07', '2026-10-16 15:51:48', '', '2026-10-16 15:51:49', '', NULL, NULL);

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

SET FOREIGN_KEY_CHECKS = 1;
