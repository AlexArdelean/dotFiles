---
name: ros2-type-check
description: When writing or modifying code in lumi_ui that uses ROS2 topics, services, or actions, cross-check the message types against the actual definitions in lumi_msgs_v2.
---

When working in `/home/alex/lumi_ui` and touching any code that references a ROS2 message type from `lumi_msgs_v2`, you MUST cross-check the type against the ground-truth definition files in `/home/alex/lumi_ws/ros_ws/src/lumi_msgs_v2/`.

## When this applies

Trigger this check whenever you:
- Add or modify a type string of the form `lumi_msgs_v2/msg/X`, `lumi_msgs_v2/srv/X`, or `lumi_msgs_v2/action/X`
- Add or modify an entry in `rosMessageTypes.ts` or `socketEvents.ts`
- Add a new topic handler, service call, or action client in lumi_ui
- Access a field on a message payload (e.g. `msg.robot_state`, `req.goal_object_type`)

## How to check

1. **Resolve the definition file path** from the type string:
   - `lumi_msgs_v2/msg/Foo`    → `/home/alex/lumi_ws/ros_ws/src/lumi_msgs_v2/msg/Foo.msg`
   - `lumi_msgs_v2/srv/Foo`    → `/home/alex/lumi_ws/ros_ws/src/lumi_msgs_v2/srv/Foo.srv`
   - `lumi_msgs_v2/action/Foo` → `/home/alex/lumi_ws/ros_ws/src/lumi_msgs_v2/action/Foo.action`

2. **Read the definition file** with the Read tool.

3. **Verify existence** — if the file does not exist, the type is invalid. Report it and do not proceed with code that uses it. Suggest the correct type name by listing the available files in the relevant subfolder.

4. **Check field names** — for every field accessed in lumi_ui code (e.g. `msg.robot_state`, `response.success`), confirm that field exists in the definition file with a compatible type. For `.srv` files, the request fields are above `---` and the response fields are below.

5. **Check nested types** — if a field type is itself a `lumi_msgs_v2` message (e.g. `lumi_msgs_v2/msg/TrajectoryPlannerType`), recursively verify that type as well.

## What to report

Before writing or finalising any lumi_ui code that uses a lumi_msgs_v2 type:
- Confirm the type exists: `✓ lumi_msgs_v2/msg/RobotState exists`
- List the fields you verified and note any mismatch
- If a field is missing or renamed, show the actual definition and update the code accordingly

## Key lumi_ui files to be aware of

- `backend/src/utils/rosMessageTypes.ts` — symbolic name → ROS2 type string registry
- `backend/types/rclnodejs-interfaces.d.ts` — generated TS interfaces (may lag behind msg changes)
- `backend/src/socket/rosTopics/` — per-topic handlers; each imports a `MSG_TYPES` entry
- `shared/socketEvents.ts` — socket event type map keyed by topic name

## Known stale reference (as of 2026-04-22)

`calibrationStatus.ts` references `lumi_msgs/AutocalibrateStatus` which no longer exists. The correct package is `lumi_msgs_v2`. Flag this if you touch that file.
