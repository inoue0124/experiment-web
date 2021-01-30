class InstructionsController < ApplicationController

  def getInstruction
    @pdf_url = S3_DISCLOSE_INSTRUCTION_URL + params[:workflow_id] + "/instruction.pdf"

    render json: {
      pdf_url: @pdf_url
    },
    status: :ok
  end
end