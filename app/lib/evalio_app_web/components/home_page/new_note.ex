defmodule EvalioAppWeb.HomePage.NewNote do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-md px-6 py-4 w-[720px] h-[60px] flex flex-row items-center">
      <button class="text-gray-400 text-lg hover:text-gray-500 transition-colors" phx-click="toggle_form">
        Take a note...
      </button>
      <div class="flex-grow"></div>
      <div class="flex justify-end items-center space-x-6">
        <button class="w-[45px] h-[45px] rounded-lg bg-[#FFFFFF] hover:bg-[#171717] transition-all cursor-pointer flex items-center justify-center group">
          <svg class="w-[25px] h-[25px] text-[#171717] group-hover:text-[#FFFFFF] transition-colors" viewBox="0 0 35 30" xmlns="http://www.w3.org/2000/svg">
            <path fill="currentColor" d="M8.08029 11.4773L4.31301 15.6609L2.8009 14.1495C2.16003 13.5086 1.12199 13.5086 0.48078 14.1495C-0.160431 14.7903 -0.160089 15.8284 0.48078 16.4696L3.21515 19.204C3.52277 19.5164 3.94182 19.6873 4.31369 19.6873C4.32866 19.6873 4.34144 19.6873 4.35641 19.6862C4.57911 19.6805 4.79832 19.6296 5.0007 19.5365C5.20308 19.4434 5.38438 19.3101 5.53356 19.1446L10.4554 13.6759C11.0621 13.0019 11.0066 11.9648 10.3338 11.3578C9.72092 10.7527 8.68869 10.8074 8.08029 11.4773ZM8.08029 0.542538L4.31301 4.7234L2.8009 3.21197C2.16003 2.5711 1.12199 2.5711 0.48078 3.21197C-0.160431 3.85284 -0.160089 4.89088 0.48078 5.53209L3.21515 8.26646C3.52277 8.57887 3.94182 8.74976 4.31369 8.74976C4.32866 8.74976 4.34144 8.74976 4.35641 8.74867C4.57911 8.74303 4.79832 8.6921 5.0007 8.599C5.20308 8.5059 5.38438 8.37257 5.53356 8.20713L10.4554 2.73838C11.0621 2.06442 11.0066 1.02734 10.3338 0.420311C9.72092 -0.184122 8.68869 -0.130802 8.08029 0.542538ZM3.28146 22.907C1.46926 22.907 0.00021362 24.376 0.00021362 26.1882C0.00021362 28.0004 1.46926 29.4695 3.28146 29.4695C5.09367 29.4695 6.56271 28.0004 6.56271 26.1882C6.56271 24.4382 5.09367 22.907 3.28146 22.907ZM17.5002 6.56226H32.8127C34.0206 6.56226 35.0002 5.58267 35.0002 4.37476C35.0002 3.16685 34.0206 2.18726 32.8127 2.18726H17.5002C16.2903 2.18726 15.3127 3.16685 15.3127 4.37476C15.3127 5.58267 16.2903 6.56226 17.5002 6.56226ZM32.8127 13.1248H17.5002C16.2903 13.1248 15.3127 14.1023 15.3127 15.3123C15.3127 16.5222 16.2923 17.4998 17.5002 17.4998H32.8127C34.0206 17.4998 35.0002 16.5202 35.0002 15.3123C35.0002 14.1044 34.0227 13.1248 32.8127 13.1248ZM32.8127 24.0623H13.1252C11.9173 24.0623 10.9377 25.0419 10.9377 26.2498C10.9377 27.4577 11.9173 28.4373 13.1252 28.4373H32.8127C34.0206 28.4373 35.0002 27.4577 35.0002 26.2498C35.0002 25.0419 34.0227 24.0623 32.8127 24.0623Z" />
          </svg>
        </button>
        <button class="w-[45px] h-[45px] rounded-lg bg-[#FFFFFF] hover:bg-[#171717] transition-all cursor-pointer flex items-center justify-center group">
          <svg class="w-[25px] h-[25px] text-[#171717] group-hover:text-[#FFFFFF] transition-colors" viewBox="0 0 35 35" xmlns="http://www.w3.org/2000/svg">
            <path fill="currentColor" d="M29.1667 2.91667H27.7083V1.45833C27.7083 1.07156 27.5547 0.700627 27.2812 0.427136C27.0077 0.153645 26.6368 0 26.25 0C25.8632 0 25.4923 0.153645 25.2188 0.427136C24.9453 0.700627 24.7917 1.07156 24.7917 1.45833V2.91667H10.2083V1.45833C10.2083 1.07156 10.0547 0.700627 9.7812 0.427136C9.50771 0.153645 9.13677 0 8.75 0C8.36323 0 7.99229 0.153645 7.7188 0.427136C7.44531 0.700627 7.29167 1.07156 7.29167 1.45833V2.91667H5.83333C4.28624 2.91667 2.80251 3.53125 1.70854 4.62521C0.614582 5.71917 0 7.2029 0 8.75V29.1667C0 30.7138 0.614582 32.1975 1.70854 33.2915C2.80251 34.3854 4.28624 35 5.83333 35H29.1667C30.7138 35 32.1975 34.3854 33.2915 33.2915C34.3854 32.1975 35 30.7138 35 29.1667V8.75C35 7.2029 34.3854 5.71917 33.2915 4.62521C32.1975 3.53125 30.7138 2.91667 29.1667 2.91667ZM32.0833 29.1667C32.0833 29.9402 31.776 30.6821 31.2291 31.2291C30.6821 31.776 29.9402 32.0833 29.1667 32.0833H5.83333C5.05979 32.0833 4.31792 31.776 3.77094 31.2291C3.22396 30.6821 2.91667 29.9402 2.91667 29.1667V8.75C2.91667 7.97645 3.22396 7.23459 3.77094 6.68761C4.31792 6.14062 5.05979 5.83333 5.83333 5.83333H7.29167V7.29167C7.29167 7.67844 7.44531 8.04937 7.7188 8.32286C7.99229 8.59635 8.36323 8.75 8.75 8.75C9.13677 8.75 9.50771 8.59635 9.7812 8.32286C10.0547 8.04937 10.2083 7.67844 10.2083 7.29167V5.83333H24.7917V7.29167C24.7917 7.67844 24.9453 8.04937 25.2188 8.32286C25.4923 8.59635 25.8632 8.75 26.25 8.75C26.6368 8.75 27.0077 8.59635 27.2812 8.32286C27.5547 8.04937 27.7083 7.67844 27.7083 7.29167V5.83333H29.1667C29.9402 5.83333 30.6821 6.14062 31.2291 6.68761C31.776 7.23459 32.0833 7.97645 32.0833 8.75V29.1667Z" />
            <path fill="currentColor" d="M27.7083 10.2083H7.29167C6.90489 10.2083 6.53396 10.362 6.26047 10.6355C5.98698 10.909 5.83333 11.2799 5.83333 11.6667C5.83333 12.0534 5.98698 12.4244 6.26047 12.6979C6.53396 12.9714 6.90489 13.125 7.29167 13.125H27.7083C28.0951 13.125 28.466 12.9714 28.7395 12.6979C29.013 12.4244 29.1667 12.0534 29.1667 11.6667C29.1667 11.2799 29.013 10.909 28.7395 10.6355C28.466 10.362 28.0951 10.2083 27.7083 10.2083ZM10.2083 17.5H7.29167C6.90489 17.5 6.53396 17.6536 6.26047 17.9271C5.98698 18.2006 5.83333 18.5716 5.83333 18.9583C5.83333 19.3451 5.98698 19.716 6.26047 19.9895C6.53396 20.263 6.90489 20.4167 7.29167 20.4167H10.2083C10.5951 20.4167 10.966 20.263 11.2395 19.9895C11.513 19.716 11.6667 19.3451 11.6667 18.9583C11.6667 18.5716 11.513 18.2006 11.2395 17.9271C10.966 17.6536 10.5951 17.5 10.2083 17.5ZM10.2083 24.7917H7.29167C6.90489 24.7917 6.53396 24.9453 6.26047 25.2188C5.98698 25.4923 5.83333 25.8632 5.83333 26.25C5.83333 26.6368 5.98698 27.0077 6.26047 27.2812C6.53396 27.5547 6.90489 27.7083 7.29167 27.7083H10.2083C10.5951 27.7083 10.966 27.5547 11.2395 27.2812C11.513 27.0077 11.6667 26.6368 11.6667 26.25C11.6667 25.8632 11.513 25.4923 11.2395 25.2188C10.966 24.9453 10.5951 24.7917 10.2083 24.7917ZM18.9583 17.5H16.0417C15.6549 17.5 15.284 17.6536 15.0105 17.9271C14.737 18.2006 14.5833 18.5716 14.5833 18.9583C14.5833 19.3451 14.737 19.716 15.0105 19.9895C15.284 20.263 15.6549 20.4167 16.0417 20.4167H18.9583C19.3451 20.4167 19.716 20.263 19.9895 19.9895C20.263 19.716 20.4167 19.3451 20.4167 18.9583C20.4167 18.5716 20.263 18.2006 19.9895 17.9271C19.716 17.6536 19.3451 17.5 18.9583 17.5ZM18.9583 24.7917H16.0417C15.6549 24.7917 15.284 24.9453 15.0105 25.2188C14.737 25.4923 14.5833 25.8632 14.5833 26.25C14.5833 26.6368 14.737 27.0077 15.0105 27.2812C15.284 27.5547 15.6549 27.7083 16.0417 27.7083H18.9583C19.3451 27.7083 19.716 27.5547 19.9895 27.2812C20.263 27.0077 20.4167 26.6368 20.4167 26.25C20.4167 25.8632 20.263 25.4923 19.9895 25.2188C19.716 24.9453 19.3451 24.7917 18.9583 24.7917ZM27.7083 17.5H24.7917C24.4049 17.5 24.034 17.6536 23.7605 17.9271C23.487 18.2006 23.3333 18.5716 23.3333 18.9583C23.3333 19.3451 23.487 19.716 23.7605 19.9895C24.034 20.263 24.4049 20.4167 24.7917 20.4167H27.7083C28.0951 20.4167 28.466 20.263 28.7395 19.9895C29.013 19.716 29.1667 19.3451 29.1667 18.9583C29.1667 18.5716 29.013 18.2006 28.7395 17.9271C28.466 17.6536 28.0951 17.5 27.7083 17.5ZM27.7083 24.7917H24.7917C24.4049 24.7917 24.034 24.9453 23.7605 25.2188C23.487 25.4923 23.3333 25.8632 23.3333 26.25C23.3333 26.6368 23.487 27.0077 23.7605 27.2812C24.034 27.5547 24.4049 27.7083 24.7917 27.7083H27.7083C28.0951 27.7083 28.466 27.5547 28.7395 27.2812C29.013 27.0077 29.1667 26.6368 29.1667 26.25C29.1667 25.8632 29.013 25.4923 28.7395 25.2188C28.466 24.9453 28.0951 24.7917 27.7083 24.7917Z" />
          </svg>
        </button>
        <button class="w-[45px] h-[45px] rounded-lg bg-[#FFFFFF] hover:bg-[#171717] transition-all cursor-pointer flex items-center justify-center group">
          <svg class="w-[25px] h-[25px] text-[#171717] group-hover:text-[#FFFFFF] transition-colors" viewBox="0 0 32 33" xmlns="http://www.w3.org/2000/svg">
            <path fill="currentColor" d="M27.1285 0.257324H4.92853C3.66686 0.257324 2.45686 0.772068 1.56472 1.68832C0.672584 2.60457 0.171387 3.84727 0.171387 5.14304V27.943C0.171387 29.2388 0.672584 30.4815 1.56472 31.3978C2.45686 32.314 3.66686 32.8288 4.92853 32.8288H27.1285C28.3902 32.8288 29.6002 32.314 30.4923 31.3978C31.3845 30.4815 31.8857 29.2388 31.8857 27.943V5.14304C31.8857 3.84727 31.3845 2.60457 30.4923 1.68832C29.6002 0.772068 28.3902 0.257324 27.1285 0.257324ZM12.8571 8.40018C13.4844 8.40018 14.0975 8.59121 14.6191 8.94911C15.1406 9.30701 15.5471 9.81571 15.7871 10.4109C16.0272 11.006 16.09 11.6609 15.9676 12.2928C15.8452 12.9246 15.5432 13.505 15.0996 13.9605C14.6561 14.416 14.091 14.7262 13.4758 14.8519C12.8606 14.9776 12.223 14.9131 11.6434 14.6665C11.0639 14.42 10.5686 14.0025 10.2202 13.4669C9.87167 12.9313 9.68567 12.3015 9.68567 11.6573C9.68567 10.7935 10.0198 9.96501 10.6146 9.35418C11.2093 8.74334 12.016 8.40018 12.8571 8.40018ZM8.33782 22.3733L8.87696 29.5716H4.92853C4.59289 29.5657 4.26773 29.4506 3.99987 29.2428C3.732 29.035 3.53526 28.7453 3.43796 28.4153L8.33782 22.3733ZM28.7142 27.943C28.7142 28.375 28.5472 28.7892 28.2498 29.0946C27.9524 29.4 27.5491 29.5716 27.1285 29.5716H12.8571L21.531 17.3248C21.6655 17.1341 21.8386 16.9758 22.0384 16.8605C22.2383 16.7452 22.4601 16.6758 22.6885 16.657C22.9182 16.6375 23.1493 16.6697 23.3656 16.7513C23.582 16.8328 23.7784 16.9618 23.9412 17.1293L28.7142 22.0965V27.943Z" />
          </svg>
        </button>
      </div>
    </div>
    """
  end
end
