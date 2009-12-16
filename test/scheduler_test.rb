require File.dirname(__FILE__) + '/test_helper'


context "Resque::Scheduler" do

  setup do
    Resque.redis.flush_all
    Resque::Scheduler.clear_schedule!
  end

  test "enqueue_from_config puts stuff in the resque queue" do
    assert_equal(0, Resque.size(:ivar))
    Resque::Scheduler.enqueue_from_config('cron' => "* * * * *", 'class' => 'SomeIvarJob', 'args' => "/tmp")
    assert_equal(1, Resque.size(:ivar))
  end

  test "config makes it into the rufus scheduler" do
    assert_equal(0, Resque::Scheduler.rufus_scheduler.all_jobs.size)

    Resque.schedule = {:some_ivar_job => {'cron' => "* * * * *", 'class' => 'SomeIvarJob', 'args' => "/tmp"}}
    Resque::Scheduler.run(false)

    assert_equal(1, Resque::Scheduler.rufus_scheduler.all_jobs.size)
  end

end