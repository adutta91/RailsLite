require 'json'

class Flash
  def initialize(req)
    cookies = req.cookies['_rails_lite_app_flash']

    if cookies
      @flash_cookie = JSON.parse(cookies)
    else
      @flash_cookie = {}
    end
  end

  def [](key)
    @flash_cookie[key]
  end

  def []=(key, value)
    @flash_cookie[key] = value
  end

  def clear_flash(res)
    @flash_cookie = {}
    res.set_cookie('_rails_lite_app_flash', { path: '/', value: @flash_cookie.to_json })
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', { path: '/', value: @flash_cookie.to_json })
  end

  def now(req)
    cookies = req.cookies['_rails_lite_app_flash']
    if cookies
      @now_cookie = JSON.parse(cookies)
    else
      @now_cookie = {}
    end
  end

end
