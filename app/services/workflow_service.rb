# -*- encoding : utf-8 -*-

# The helper methods for the workflow.
module WorkflowService
  include MqHelper # methods: send_message_for_workflow

  WORKFLOW_STATE_NOT_STARTED = "Not started"
  WORKFLOW_STATE_STARTED = "Started"
  WORKFLOW_STATE_FAILED = "Failed"
  WORKFLOW_STATE_FINISHED = "Finished"

  def handle_workflow_message(message)
    begin
      w = Work.find(message['PID'])
      continue_workflow(w) if get_current_step(w)
    rescue => e
      logger.error "Could not handle workflow message #{message} due to error #{e.message}"
      logger.error e.backtrace.join("\n")
    end
  end

  # Continue the workflow for the work.
  #
  # @param work The work to continue the workflow for.
  def continue_workflow(work)
    handle_current_step(work)
    message = create_workflow_message(work)
    send_message_for_workflow(message)
  end

  private
  # Handles the current step for the given work.
  # Finds the next step and performs it.
  #
  # @param work The work
  def handle_current_step(work)
    step = get_current_step(work)
    raise ArgumentError.new('No more steps for the workflow of this work.') unless step
    begin
      set_state(work, step['name'], WORKFLOW_STATE_STARTED)
      perform_step(work, step)
      set_state(work, step['name'], WORKFLOW_STATE_FINISHED)
    rescue => e
      set_state(work, step['name'], WORKFLOW_STATE_FAILED)
      work.workflow_error = e.inspect
      raise e
    ensure
      work.save
    end
  end

  # Performs the step for the given work.
  #
  # @param work The work to perform the step upon.
  # @param step The step to perform on the work.
  def perform_step(work, step)
    # TODO Workflow steps implemented here
    logger.warn "Not implemented handling of step #{step} for #{work} "

    work.step
  end

  #
  def get_current_step(work)
    work.step.each do |s|
      return s unless s['state'] == WORKFLOW_STATE_FINISHED
    end
    return false
  end

  # Set a given step to a given state value.
  # TODO: There might be a issue, if more than one step has the same name.
  #
  # @param work The work to have its step updated.
  # @param step_name The name of the step to update the state for.
  # @param new_state The new value for the state.
  def set_state(work, step_name, new_state)
    work.step = work.step.each do |s|
      s['state'] = new_state if s['name'] == step_name
    end
  end

  # Format:
  # UUID - The unique identifier for the work
  # PID - The internal PID for the work.
  #
  # @param work The work to create the DOD object for.
  # @return The message in JSON format.
  def create_workflow_message(work)
    message = Hash.new
    message['UUID'] = work.uuid
    message['PID'] = work.pid

    message.to_json()
  end
end
