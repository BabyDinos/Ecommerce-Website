defmodule EcommercewebsiteWeb.HomeLive do
  use EcommercewebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      </head>
      <body>
      <div class="bg-white flex flex-col">
      <div
        class="self-center flex w-full max-w-[1277px] flex-col max-md:max-w-full"
      >
        <div class="self-center w-full px-5 max-md:max-w-full">
          <div class="gap-5 flex max-md:flex-col max-md:items-stretch max-md:gap-0">
            <div
              class="flex flex-col items-stretch w-[16%] max-md:w-full max-md:ml-0"
            >
            </div>
            <div
              class="flex flex-col items-stretch w-[84%] ml-5 max-md:w-full max-md:ml-0"
            >
              <div
                class="flex-col overflow-hidden relative flex min-h-[1112px] grow pl-0 pr-20 pt-5 pb-96 max-md:max-w-full max-md:mt-10 max-md:pr-5 max-md:pb-24"
              >
                <img
                  loading="lazy"
                  src="https://cdn.builder.io/api/v1/image/assets/TEMP/79872e3c-ffe1-487b-a2a5-41510d3d4eb6?"
                  class="absolute z-[-1] h-full w-full object-cover object-center inset-0"
                />
                <div
                  class="relative flex mb-0 w-[609px] max-w-full flex-col self-start max-md:mb-2.5"
                >
                  <div
                    class="text-slate-950 text-4xl font-black leading-9 whitespace-nowrap self-center"
                  >
                    Marcplace
                  </div>
                  <div
                    class="text-slate-900 text-5xl font-medium leading-[66px] self-stretch mt-64 max-md:max-w-full max-md:text-4xl max-md:mt-10"
                  >
                    Introduce Your Product Quickly & Effectively
                  </div>
                  <div
                    class="text-slate-500 text-lg leading-8 self-stretch mt-5 max-md:max-w-full"
                  >
                    Welcome to Marcplace—an innovative platform that empowers you to unleash
                    your entrepreneurial spirit without any upfront costs or restrictions.
                    With our user-friendly website, you can effortlessly create your very own online
                    shop at absolutely no cost. No hidden fees, no fine print—just the freedom to
                    showcase and sell your products without any financial barriers.
                  </div>
                  <button
                    class="flex justify-center text-slate-900 text-xl text-center font-medium leading-7 self-center border-[color:var(--colour-main-blue-900,#091133)] w-[189px] max-w-full grow mt-16 pl-14 pr-14 py-3.5 rounded-sm border-2 border-solid max-md:mt-10 max-md:px-5 whitespace-nowrap"
                  >
                    <a href="/users/register"> Start now! </a>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div
          class="self-center w-full mt-28 pr-20 max-md:max-w-full max-md:mt-10 max-md:pr-5"
        >
          <div class="gap-5 flex max-md:flex-col max-md:items-stretch max-md:gap-0">
            <div
              class="flex flex-col items-stretch w-[54%] max-md:w-full max-md:ml-0"
            >
              <div class="flex flex-col my-auto max-md:max-w-full max-md:mt-10">
                <div
                  class="text-slate-900 text-4xl font-medium leading-10 self-stretch max-md:max-w-full"
                >
                  Zero-Cost Setup
                </div>
                <div
                  class="text-slate-500 text-base leading-7 self-stretch mt-4 max-md:max-w-full"
                >
                  Creating an online shop on our platform comes with no financial burden.
                  In an industry where setup costs can be a hindrance, we offer a revolutionary
                  approach-entrepreneurs can embark on their online business journey without spending a dime.
                  No setup fees or hidden costs mean more resources for product development and marketing,
                  allowing users to kickstart their ecommerce venture hassle-free.
                </div>
                <div class="self-stretch mt-20 max-md:max-w-full max-md:mt-10">
                  <div
                    class="gap-5 flex max-md:flex-col max-md:items-stretch max-md:gap-0"
                  >
                    <div
                      class="flex flex-col items-stretch w-6/12 max-md:w-full max-md:ml-0"
                    >
                      <div class="flex grow flex-col max-md:mt-8">
                        <img
                          loading="lazy"
                          src="/images/open.jpg"
                          class="object-contain object-center w-[78px] overflow-hidden max-w-full self-start"
                        />
                        <div
                          class="text-slate-900 text-base font-medium leading-7 mt-2.5 self-start"
                        >
                          Instant Access, Zero Investment
                        </div>
                        <div
                          class="text-gray-500 text-xs leading-5 mt-3 self-start"
                        >
                          Get instant access to your online shop with zero upfront investment,
                         allowing you to focus on what you do best—selling.
                        </div>
                      </div>
                    </div>
                    <div
                      class="flex flex-col items-stretch w-6/12 ml-5 max-md:w-full max-md:ml-0"
                    >
                      <div class="flex grow flex-col max-md:mt-8">
                        <img
                          loading="lazy"
                          src="/images/coupon.jpg"
                          class="object-contain object-center w-[78px] overflow-hidden max-w-full self-start"
                        />
                        <div
                          class="text-slate-900 text-base font-medium leading-7 mt-2.5 self-start"
                        >
                          No Strings Attached
                        </div>
                        <div
                          class="text-gray-500 text-xs leading-5 mt-3 self-start"
                        >
                          Experience the freedom of building your online presence
                          without any strings attached—no hidden fees, no fine print.
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div
              class="flex flex-col items-stretch w-[46%] ml-5 max-md:w-full max-md:ml-0"
            >
              <img
                loading="lazy"
                src="https://cdn.builder.io/api/v1/image/assets/TEMP/c8dd0ca9-37eb-49e8-b19a-364cbea12ae6?"
                class="aspect-[1.03] object-contain object-center w-full overflow-hidden grow max-md:max-w-full max-md:mt-8"
              />
            </div>
          </div>
        </div>
        <div
          class="self-center w-full max-w-[1080px] mt-56 px-5 max-md:max-w-full max-md:mt-10"
        >
          <div class="gap-5 flex max-md:flex-col max-md:items-stretch max-md:gap-0">
            <div
              class="flex flex-col items-stretch w-[55%] max-md:w-full max-md:ml-0"
            >
              <img
                loading="lazy"
                src="https://cdn.builder.io/api/v1/image/assets/TEMP/c43fb319-3c0b-413d-a339-6b3ca4abc680?"
                class="aspect-[1.52] object-contain object-center w-full overflow-hidden grow max-md:max-w-full max-md:mt-10"
              />
            </div>
            <div
              class="flex flex-col items-stretch w-[45%] ml-5 max-md:w-full max-md:ml-0"
            >
              <div class="flex flex-col my-auto max-md:max-w-full max-md:mt-10">
                <div
                  class="text-slate-900 text-4xl font-medium leading-10 self-stretch max-md:max-w-full"
                >
                  Freedom to Sell Anywhere
                </div>
                <div
                  class="text-slate-500 text-base leading-7 self-stretch mt-4 max-md:max-w-full"
                >
                  At Marcplace, we believe in breaking down geographical barriers.
                  Our platform enables users to not only reach a local audience but also connect
                  with customers globally. With no restrictions on where and how users can sell,
                  entrepreneurs can tap into new markets and diversify their customer base.
                  Expand your business horizons with the freedom to sell anywhere in the world.
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="self-center w-full mt-56 px-5 max-md:max-w-full max-md:mt-10">
          <div class="gap-5 flex max-md:flex-col max-md:items-stretch max-md:gap-0">
            <div
              class="flex flex-col items-stretch w-[48%] max-md:w-full max-md:ml-0"
            >
              <img
                loading="lazy"
                src="https://cdn.builder.io/api/v1/image/assets/TEMP/f41faf2c-f9f6-4238-999a-5ffa4101359a?"
                class="aspect-[1.4] object-contain object-center w-full overflow-hidden grow max-md:max-w-full max-md:mt-10"
              />
            </div>
            <div
              class="flex flex-col items-stretch w-[52%] ml-5 max-md:w-full max-md:ml-0"
            >
              <div class="flex flex-col my-auto max-md:max-w-full max-md:mt-10">
                <div
                  class="text-slate-900 text-4xl font-medium leading-10 self-stretch max-md:max-w-full"
                >
                  Unlimited Creativity and Control
                </div>
                <div
                  class="text-slate-500 text-base leading-7 self-stretch mt-4 max-md:max-w-full"
                >
                  Your brand, your rules. MarketPlace Marcus provides users with unparalleled creative freedom and control.
                 Customize your online shop to reflect your unique brand identity effortlessly.
                 With user-friendly tools and a range of customization options, you can design a storefront
                 that resonates with your vision. Take control of your online presence and showcase your
                 products in a way that sets you apart from the competition.
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div
        class="flex-col fill-violet-100 overflow-hidden relative flex min-h-[934px] w-full mt-40 mb-20 pt-64 pb-9 px-20 self-center max-md:max-w-full max-md:my-10 max-md:pt-24 max-md:px-5"
      >
        <img
          loading="lazy"
          src="https://cdn.builder.io/api/v1/image/assets/TEMP/06dc65f6-123a-473d-aab7-8f6c8a9a73f4?"
          class="absolute z-[-1] h-full w-full object-cover object-center inset-0"
        />
        <div class="relative self-center flex w-[580px] max-w-full flex-col">
          <div
            class="text-slate-900 text-center text-4xl font-medium leading-10 self-center w-full"
          >
            Want to learn more?
          </div>
          <div
            class="flex justify-center space-x-5 text-slate-500 text-center text-base leading-7 self-stretch mt-4 max-md:max-w-full"
          >
            <a href="https://www.linkedin.com/in/marcus-lau-2a904918b">
            <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" width="175" class="h-full"/>
            </a>
            <a href="https://github.com/BabyDinos">
            <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" width = "175" class="h-full"/>
            </a>
          </div>

          <div
            class="text-gray-500 text-center text-sm leading-6 self-center max-w-[350px] mt-16 max-md:mt-10"
          >
            Disclaimer: This is a project, not an actual ecommerce website
          </div>
          <div
            class="text-black text-4xl font-black leading-9 self-center whitespace-nowrap mt-56 max-md:mt-10"
          >
            Marcplace
          </div>
        </div>
      </div>
    </div>


    </body>
    """
    end

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

  end
