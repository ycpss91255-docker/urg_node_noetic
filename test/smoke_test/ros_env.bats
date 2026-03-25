#!/usr/bin/env bats

setup() {
    load "${BATS_TEST_DIRNAME}/test_helper"
}

@test "ROS_DISTRO is set" {
    assert [ -n "${ROS_DISTRO}" ]
}

@test "ROS 1 setup.bash exists" {
    assert [ -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]
}

@test "ROS 1 setup.bash can be sourced" {
    run bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash"
    assert_success
}

@test "urg_node is installed" {
    run dpkg -l ros-${ROS_DISTRO}-urg-node
    assert_success
}

@test "laser_proc is installed" {
    run dpkg -l ros-${ROS_DISTRO}-laser-proc
    assert_success
}

@test "git is available" {
    run git --version
    assert_success
}

@test "sudo passwordless works" {
    run sudo true
    assert_success
}

@test "User is not root" {
    assert [ "$(id -u)" -ne 0 ]
}

@test "Timezone is Asia/Taipei" {
    run cat /etc/timezone
    assert_output "Asia/Taipei"
}

@test "LANG is en_US.UTF-8" {
    assert_equal "${LANG}" "en_US.UTF-8"
}

@test "entrypoint.sh exists and executable" {
    assert [ -x "/entrypoint.sh" ]
}

@test "Work directory exists" {
    assert [ -d "${HOME}/work" ]
}
