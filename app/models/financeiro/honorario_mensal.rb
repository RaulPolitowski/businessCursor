class Financeiro::HonorarioMensal < Financeiro::FiscalDatabase
  self.table_name = 'honorariomensal'

  def self.send_whatsapp
    #headless = Headless.new
    #headless.start

    prefs = {
      plugins: {
        always_open_pdf_externally: true
      }
    }
    prefes = {
      prompt_for_download: false,
      default_directory: Rails.root.join('tmp').to_s
    }
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference(:download, prefes)
    browser = Watir::Browser.new :chrome, prefs: prefs, options: options, :switches => ['--ignore-certificate-errors']
    browser.goto 'https://web.whatsapp.com/'
    texto = "Olá bebê, bora tomar uma? %0a ;)"
    sleep 15
    aux = true
    i = 1
    while aux
      textaux = " msg #{i}"
      browser.goto 'https://wa.me/5545988043418?text=' + texto + textaux

      sleep 1 unless browser.a(id: 'action-button').present?
      browser.a(id: 'action-button').click

      sleep 1 unless browser.a(xpath: '//*[@id="fallback_block"]/div/div/a').present?
      browser.a(xpath: '//*[@id="fallback_block"]/div/div/a').click

      sleep 1 unless browser.button(xpath: '//*[@id="main"]/footer/div[1]/div/span[2]/div/div[2]/div[2]/button').present?
      browser.button(xpath: '//*[@id="main"]/footer/div[1]/div/span[2]/div/div[2]/div[2]/button').click

      sleep 60
      i += 1

      if i > 15
        aux = false
      end
    end
  end
end
