function if_admin(msg)
	admin_name = "ادمین"
	is_admin = false
	admintab = admins(msg.chat.id)
	for i=1,#admintab.result do
		if admintab.result[i].user.id == msg.from.id then
			is_admin = true
		end
	end
	if msg.from.id == sudo_id then
		admin_name = "بابایی"
		is_admin = true
	end
	return is_admin
end

function manage_group(msg)
	msg.text = msg.text:gsub("@tgGuardbot","")
	if not groups[gpid] then
		groups[gpid] = {anti=true,welcome="def"}
		save_data("groups.json", groups)
	end
	
	if msg.text:lower() == "/info" then
		if msg.reply_to_message then
			fname = (msg.reply_to_message.from.first_name or " "):gsub("`","")
			lname = (msg.reply_to_message.from.last_name or " "):gsub("`","")
			info = "نام: "..fname.."\n\n"
				.."فامیل: "..lname.."\n\n"
				.."یوزرنیم: @"..(msg.reply_to_message.from.username or "-----").."\n\n"
				.."شناسه: "..msg.reply_to_message.from.id.."\n\n"
				.."نام گروه: "..msg.chat.title.."\n\n"
				.."شناسه گروه: "..msg.chat.id.."\n\n"
				.."نوع گروه: "..msg.chat.type
			if msg.reply_to_message.forward_from then
				fname = (msg.reply_to_message.forward_from.first_name or ""):gsub("`","")
				lname = (msg.reply_to_message.forward_from.last_name or ""):gsub("`","")
				info = info.."\n==============================\nمشخصات ارسال کننده اصلی:\n\n"
					.."نام: "..fname.."\n\n"
					.."فامیل: "..lname.."\n\n"
					.."یوزرنیم: @"..(msg.reply_to_message.forward_from.username or "-----").."\n\n"
					.."شناسه: "..msg.reply_to_message.forward_from.id
			end
		else
			fname = (msg.from.first_name or ""):gsub("`","")
			lname = (msg.from.last_name or ""):gsub("`","")
			info = "نام: "..fname.."\n\n"
				.."فامیل: "..lname.."\n\n"
				.."یوزرنیم: @"..(msg.from.username or "-----").."\n\n"
				.."شناسه: "..msg.from.id.."\n\n"
				.."نام گروه: "..msg.chat.title.."\n\n"
				.."شناسه گروه: "..msg.chat.id.."\n\n"
				.."نوع گروه: "..msg.chat.type
		end
		return send_msg(msg.chat.id, "`"..info.."`", true)
	elseif msg.text:lower() == "/id" then
		if msg.reply_to_message then
			return send_msg(msg.chat.id, msg.reply_to_message.from.id, false)
		else
			return send_msg(msg.chat.id, msg.from.id, false)
		end
	elseif msg.text:lower() == "/about" or msg.text:lower() == "about" then
		about_txt = "*Telegram Guard Robot* v"..bot_version.."\n`رباتی منحصر به فرد و رایگان برای مدیران کانال ها و گروه ها همچنین افرادی که میخواهند خاص و متفاوت باشند.\nامکانات ربات:`\n"..ghabeliyat
			.."\n\n`طراحی و ساخت در تیم تلگرام ممبر`"
		about_key = {{{text = "کانال تلگرام ممبر" , url = "https://telegram.me/tgMember"},{text = "پشتیبان ربات" , url = "https://telegram.me/sajjad_021"}},{{text = "سازنده ربات" , url = "https://telegram.me/tgMember"},{text = "سفارش ربات" , url = "https://telegram.me/sajjad_021"}}}
		return send_inline(msg.chat.id, about_txt, about_key)
	end
	
	statuss = mem_info(msg.chat.id, bot.id)
	if statuss then
		if statuss.result then
			if statuss.result.status then
				if statuss.result.status == "administrator" then
					master = true
				else
					master = false
				end
			else
				master = false
			end
		else
			master = false
		end
	else
		master = false
	end

	intxt = msg.text:lower()
	if intxt:find('telegram.me') or intxt:find('tlgrm.me') then
		if if_admin(msg) then
			return
		end
		if not master then
			return send_msg(msg.chat.id, "`تبلیغات در گروه ممنوع است، در صورت تکرار با شما برخورد میشود`", true)
		else
			if groups[gpid].ads then
				if groups[gpid].ads == "warn" then
					return send_msg(msg.chat.id, "`تبلیغات در گروه ممنوع است، در صورت تکرار با شما برخورد میشود`", true)
				elseif groups[gpid].ads == "kick" then
					send_msg(msg.chat.id, "`تبلیغات در گروه ممنوع است.`", true)
					return kick(msg.chat.id, msg.from.id)
				else
					return
				end
			else
				return send_msg(msg.chat.id, "`تبلیغات در گروه ممنوع است، در صورت تکرار با شما برخورد میشود`", true)
			end
		end
	end
	
	if msg.text:lower() == "/help" or msg.text:lower() == "help" or msg.text == "راهنما" then
		if not master then
			text = "ربات نگهبان گروه و ضد لینک:\n`این ربات مدیر گروه نشده است و فقط 2 دستور آن فعال میباشد. برای فعال کردن همه ی قابلیت ها لازم است که ربات را مدیر گروه کنید. زمانی که ربات مدیر گروه نیست، واکنش به تبلیغات فقط اخطار است و پیام خوش آمد گویی نیز فقط پیشفرض میباشد همچنین نمیتوانید برای گروه قوانین ثبت کنید.\n\n`"
				.."/help\nراهنمای ربات\n"
				.."==============================\n"
				.."/about\nدرباره سازنده ربات\n"
				.."==============================\n"
				.."/info\nدریافت مشخصات شما و گروه. اگر دستور را با شخصی رپلی کنید مشخصات آن شخص را به دست می آورید\n"
				.."==============================\n"
				.."/id\nدریافت شناسه تلگرام. اگر دستور را با شخصی رپلی کنید شناسه ی شخص را به دست می آورید\n"
				.."==============================\n\n"
				.."`اگر تمایل به استفاده از این ربات در گروه خود دارید، ربات را به گروه خود دعوت کنید.`"
		else
			if if_admin(msg) then
				text = "لیست دستورات مدیریتی:\n\n"
					.."/kick ریپلی با شخصی\nحذف کاربر از گروه\n"
					.."==============================\n"
					.."/rules\nمشاهده ی قوانین\n"
					.."==============================\n"
					.."/modlist\nلیست مدیران گروه\n"
					.."==============================\n"
					.."/info\nدریافت مشخصات شما و گروه. اگر دستور را با شخصی رپلی کنید مشخصات آن شخص را به دست می آورید\n"
					.."==============================\n"
					.."/id\nدریافت شناسه تلگرام. اگر دستور را با شخصی رپلی کنید شناسه ی شخص را به دست می آورید\n"
					.."==============================\n"
					.."/welcome_no\nغیر فعال سازی خوش آمد گویی\n"
					.."==============================\n"
					.."/welcome_yes\nفعال سازی خوش آمد گویی\n"
					.."==============================\n"
					.."/welcome_set پیام\nثبت پیام خوش آمدگویی\n"
					.."==============================\n"
					.."/rules_set پیام\nثبت قوانین\n"
					.."==============================\n"
					.."/rules_no\nحذف قوانین\n"
					.."==============================\n"
					.."/ads_kick\nحذف تبلیغ کنندگان\n"
					.."==============================\n"
					.."/ads_warn\nاخطار به ابلیغ کنندگان\n"
					.."==============================\n"
					.."/ads_no\nبی اعتنا به تبلیغ کنندگان"
				return send_msg(msg.chat.id, text, false)
			else
				text = "ربات نگهبان گروه و ضد لینک:\n\n"
					.."/help\nراهنمای ربات\n"
					.."==============================\n"
					.."/about\nدرباره سازنده ربات\n"
					.."==============================\n"
					.."/kickme\nحذف شما از گروه\n"
					.."==============================\n"
					.."/rules\nمشاهده ی قوانین\n"
					.."==============================\n"
					.."/modlist\nلیست مدیران گروه\n"
					.."==============================\n"
					.."/info\nدریافت مشخصات شما و گروه. اگر دستور را با شخصی رپلی کنید مشخصات آن شخص را به دست می آورید\n"
					.."==============================\n"
					.."/id\nدریافت شناسه تلگرام. اگر دستور را با شخصی رپلی کنید شناسه ی شخص را به دست می آورید\n"
					.."==============================\n\n"
					.."`اگر تمایل به استفاده از این ربات در گروه خود دارید، ربات را به گروه خود دعوت کنید.`"
			end
		end
		return send_inline(msg.chat.id, text, add_key)
	elseif msg.text:lower() == "/kickme" then
		if not master then
			return send_msg(msg.chat.id, "`من در گروه مدیر نیستم تا قابلیتم فعال بشه`", true)
		end
		if if_admin(msg) then
			return send_msg(msg.chat.id, "`شما مدیر هستید.`", true)
		end
		return kick(msg.chat.id, msg.from.id)
	elseif msg.text:lower() == "/kick" then
		if not master then
			return send_msg(msg.chat.id, "`من در گروه مدیر نیستم تا قابلیتم فعال بشه`", true)
		end
		if not if_admin(msg) then
			return send_msg(msg.chat.id, "`فقط ادمینهای من میتونن از این دستور استفاده کنن`", true)
		end
		if msg.reply_to_message then
			if if_admin(msg.reply_to_message) then
				return send_msg(msg.chat.id, "`شخص مورد نظر "..admin_name.." است و نمیتوانید او را حذف کنید.`", true)
			end
			return kick(msg.chat.id, msg.reply_to_message.from.id)
		else
			return send_msg(msg.chat.id, "`برای حذف یک نفر، این دستور روی پیام اون رپلی بشه.`", true)
		end
	elseif msg.text:lower() == "/modlist" then
		if not master then
			return send_msg(msg.chat.id, "`من در گروه مدیر نیستم تا قابلیتم فعال بشه`", true)
		end
		admintab = admins(msg.chat.id)
		adminlist = ""
		a = 0
		for i=1,#admintab.result do
			if admintab.result[i].status == "creator" then
				creator = "Leader: "..admintab.result[i].user.id.." - @"..(admintab.result[i].user.username or "-----").."\n"
			else
				a = a+1
				adminlist = adminlist..a.."- "..admintab.result[i].user.id.." - @"..(admintab.result[i].user.username or "-----").."\n"
			end
		end
		text = "لیست مدیران گروه "..msg.chat.title.."\n==============================\n"..(creator or "")..adminlist
		return send_msg(msg.chat.id, text, false)
	elseif msg.text:lower() == "/rules" then
		if not groups[gpid].rules then
			return send_msg(msg.chat.id, "`برای گروه قوانین ثبت نشده است.`", true)
		else
			return send_msg(msg.chat.id, "قوانین گروه:\n\n"..groups[gpid].rules, false)
		end
	elseif msg.text:lower() == "/welcome_no" and if_admin(msg) then
		groups[gpid].welcome = false
		save_data("groups.json", groups)
		return send_msg(msg.chat.id, "`پیام خوش آمد گویی غیر فعال شد.`", true)
	elseif msg.text:lower() == "/welcome_yes" and if_admin(msg) then
		groups[gpid].welcome = "def"
		save_data("groups.json", groups)
		return send_msg(msg.chat.id, "`پیام خوش آمد گویی فعال شد.`", true)
	elseif msg.text:find('/welcome_set') and if_admin(msg) then
		wtext = msg.text:input()
		if wtext then
			groups[gpid].welcome = wtext
			save_data("groups.json", groups)
			return send_msg(msg.chat.id, "`پیام خوش آمد گویی ثبت و فعال شد.`", true)
		else
			return send_msg(msg.chat.id, "`بعد از این دستور، پیام خوش آمدگویی مورد نظر را وارد نمایید.`", true)
		end
	elseif msg.text:lower() == "/rules_no" and if_admin(msg) then
		groups[gpid].rules = false
		save_data("groups.json", groups)
		return send_msg(msg.chat.id, "`قوانین حذف شدند.`", true)
	elseif msg.text:find('/rules_set') and if_admin(msg) then
		rtext = msg.text:input()
		if rtext then
			groups[gpid].rules = rtext
			save_data("groups.json", groups)
			return send_msg(msg.chat.id, "`قوانین ثبت شدند.`", true)
		else
			return send_msg(msg.chat.id, "`بعد از این دستور، قوانین مورد نظر را وارد نمایید.`", true)
		end
	elseif msg.text:lower() == "/ads_no" and if_admin(msg) then
		groups[gpid].ads = "no"
		save_data("groups.json", groups)
		return send_msg(msg.chat.id, "`حساسیت به تبلیغات غیر فعال شد.`", true)
	elseif msg.text:lower() == "/ads_kick" and if_admin(msg) then
		if not master then
			return send_msg(msg.chat.id, "`من در گروه مدیر نیستم تا قابلیتم فعال بشه`", true)
		end
		groups[gpid].ads = "kick"
		save_data("groups.json", groups)
		return send_msg(msg.chat.id, "`حساسیت به تبلیغات فعال و کاربرانی که تبلیغ بگذارند حذف خواهند شد.`", true)
	elseif msg.text:lower() == "/ads_warn" and if_admin(msg) then
		groups[gpid].ads = "warn"
		save_data("groups.json", groups)
		return send_msg(msg.chat.id, "`حساسیت به تبلیغات فعال و به کاربرانی که تبلیغ کنند اخطار داده خواهد شد.`", true)
	end
end

function run(msg)
	ghabeliyat = [[   - ساخت کلید شیشه ای برای کانال
   - قرار دادن لینک روی متن، هایپر لینک
   - نوشتن متن با فونتهای مختلف
   - درج متن زیر فیلم، عکس و گیف
   - حذف تبلیغات از گروه
   - پیام خوش آمدگویی در گروه
   - ثبت قوانین در گروه
   - و...]]
	start_txt = "به ربات "..bot.first_name..' خوش آمدید\n\n`در این ربات امکانات زیر را به صورت رایگان خواهید داشت:`\n'..ghabeliyat
	..'\n\n`توجه کنید!\nاین ربات ضد اسپم بوده و هرگونه اسپم و فلود را تشخیص میدهد و در صورتی که اسپم کنید از ربات بلاک میشوید و دیگر ربات به شما پاسخ نخواهد داد. دقت کنید که آنبلاک کردن رایگان نخواهد بود.`'
	keyboard = {{"نگهبان گروه و ضد تبلیغ"},{"ارسال کیبرد شیشه ای به کانال"},{"درج زیرنویس در عکس، فیلم، گیف و فایل"},{"ایجاد متن با فونتهای مختلف و هایپر لینک"},{"راهنما","درباره ما","تبلیغ و تبادل"}}
	add_key = {{{text = "افزودن ربات به گروه" , url = "https://telegram.me/tgGuardbot?startgroup=start"}}}
	blocks = load_data("blocks.json")
	users = load_data("users.json")
	groups = load_data("groups.json")
	channels = load_data("channels.json")
	userid = tostring(msg.from.id)
	gpid = tostring(msg.chat.id)
	
	if msg.chat.type == "channel" then
		return
	elseif msg.chat.type == "supergroup" or msg.chat.type == "group" then
		return manage_group(msg)
	end

	if msg.text == "/start" then
		if users[userid] then
			users[userid].username = (msg.from.username or false)
			users[userid].action = 0
			save_data("users.json", users)
			return send_key(msg.from.id, start_txt, keyboard)
		else
			users[userid] = {}
			users[userid].username = (msg.from.username or false)
			users[userid].action = 0
			save_data("users.json", users)
			return send_key(msg.from.id, start_txt, keyboard)
		end
	elseif not users[userid] then
		users[userid] = {}
		users[userid].username = (msg.from.username or false)
		users[userid].action = 0
		save_data("users.json", users)
		return send_key(msg.from.id, start_txt, keyboard)
	end
	
	if msg.text:lower() == "/rules" or msg.text:lower() == "/kickme" or msg.text:lower() == "/modlist" then
		return send_msg(msg.from.id, "`این سرویس فقط در گروه فعال است.`", true)
	elseif msg.text:lower() == "/id" then
		return send_msg(msg.from.id, msg.from.id, true)
	elseif msg.text:lower() == "/info" then
		info = "`نام: `"..(msg.from.first_name or "").."\n\n"
			.."`فامیل: `"..(msg.from.last_name or "").."\n\n"
			.."`یوزرنیم: `@"..(msg.from.username or "-----").."\n\n"
			.."`شناسه: `"..msg.from.id.."\n\n"
		return send_msg(msg.chat.id, info, true)
	elseif msg.text == "ارتباط با ما" or msg.text == "درباره ما" or msg.text:lower() == "about" or msg.text:lower() == "/about" then
		about_txt = "*Telegram Guard Robot* v"..bot_version.."\n`رباتی منحصر به فرد و رایگان برای مدیران کانال ها و گروه ها همچنین افرادی که میخواهند خاص و متفاوت باشند.\nامکانات ربات:`\n"..ghabeliyat
			.."\n\n`طراحی و ساخت در تیم تلگرام ممبر`"
		about_key = {{{text = "کانال تلگرام ممبر" , url = "https://telegram.me/tgMember"}},{{text = "ادمین و پشتیبان ربات" , url = "https://telegram.me/sajjad_021"}},{{text = "کانال سازنده ربات" , url = "https://telegram.me/tgMember"}},{{text = "سفارش ربات" , url = "https://telegram.me/sajjad_021"}}}
		return send_inline(msg.from.id, about_txt, about_key)
	elseif msg.text == "راهنما" or msg.text:lower() == "/help" or msg.text:lower() == "help" or msg.text == "راهنمای ربات" then
		help_admin = "_Admin Commands:_\n\n".."   *Block a user:*\n     `/block {telegram id}`\n\n".."   *Unblock a user:*\n     `/unblock {telegram id}`\n\n".."   *Block list:*\n     /blocklist\n\n".."   *Send message to all users:*\n     `/sendtoallpv {message}`\n\n".."   *Send message to all groups:*\n     `/sendtoallgp {message}`\n\n".."   *All users list:*\n     /users\n\n".."   *All groups list:*\n     /groups"
		help_user = "ربات Telegram Guard Bot نسخه ی "..bot_version..'\n\n'
			..'- ایجاد متن با فونتهای مختلف و هایپر لینک:\n'
			..'`از طریق این قابلیت میتوانید متون انگلیسی خود را به 4 حالت کلفت نویس، کج نویس، کد نویس و هایپر لینک و همچنین متون فارسی را با 2 حالت هایپر لینک و کد نویس بنویسید. به این قابلیت مارک داون نیز گفته میشود. هایپر لینک ها متونی هستند که با کلیک بر روی آنها لینکی باز خواهد شد.`\n\n'
			..'- ارسال کیبرد شیشه ای به کانال:\n'
			..'`از طریق این قابلیت میتوانید کیبرد شیشه ای مورد نظر خود را بسازید و با استفاده از قابلیت اینلاین، در محل مورد نظر ارسال کنید. روش کار بسیار ساده است و با توجه به توضیحی که هر کلید ارائه میکند عمل کنید. پس از ساخت کلید شیشه ای، ربات به شما پیامی حاوی یک کد ارائه میدهد که آن را باید در محل تایپ وارد کنید و منتظر بمانید تا کلیدی در بالای محل تایپ ظاهر شود، با انتخاب آن کلید کیبرد شما با کلید های شیشه ای در محل مورد نظر ارسال میگردد.`\n\n'
			..'- درج متن زیر فیلم، عکس و گیف:\n'
			..'`با استفاده از این قابلیت میتوانید در زیر عکس، فیلم و گیف متن الصاق کنید یا به عبارتی درج نویسی کنید. به این قابلیت اصطلاحا کپشن نویسی هم گفته میشود.`\n\n'
			..'- نگهبان گروه و ضد لینک:\n'
			..'`اگر ربات را به گروه خود اضافه کنید و آن را مدیر گروه قرار دهید، ربات میتواند تبلیغ کننده ها را به صورت اوتوماتیک حذف کند. این ربات در گروه قابلیت های دیگر از جمله پیام خوش آمد گویی، ثبت قوانین، ارائه ی اطلاعات اشخاص و گروه، ارائه ی شناسه تلگرام، حذف افراد با دستور و... نیز ارائه میکند.`\n\n'
			..'- تبلیغ و تبادل:\n'
			..'`در این قسمت شما میتوانید با ما در خصوص تبادل تبلیغ ارتباط برقرار کنید. تبادل و تبلیغ در این ربات، کانال تلگرام ممبر و چند کانال دیگر که در مجموع 200k میباشند، انجام خواهد شد. دقت کنید که آمار کانال و ربات به طور لحظه ای و دقیق در این بخش نمایش داده خواهد شد.`\n\n'
		if msg.chat.id == sudo_id then
			return send_msg(sudo_id, help_admin, true)
		else
			return send_msg(msg.from.id, help_user, true)
		end
	elseif msg.text == "تبلیغ و تبادل" then
		rdjvn = mem_num("@tgMember")
		i=0
		for k,v in pairs(users) do
			i=i+1
		end
		bstat = i
		text = "نمایش آمار زنده:\n     زمان: "..os.date("%F - %H:%M:%S").."\n     کانال: "..rdjvn.result.."\n     ربات: "..bstat.."\n\n`برای تبادل و درج تبلیغات خود با ما در ارتباط باشید:`"
		return send_inline(msg.from.id, text, {{{text = "ارتباط با ادمین تبلیغات" , url = "https://telegram.me/sajjad_021"}},{{text = "نرخ و شرایط تبلیغات" , url = "https://telegram.me/tgMember"}}})
	elseif msg.text == '/sendtoallgp' and msg.chat.id == sudo_id then
		if msg.reply_to_message then
			send_msg(sudo_id, "منتظر بمانید...", true)
			i=0
			for k,v in pairs(groups) do
				i=i+1
				send_fwrd(k, msg.reply_to_message.from.id, msg.reply_to_message.message_id)
			end
			return send_msg(sudo_id, "`پیام شما به "..i.." گروه ارسال شد`", true)
		else
			return send_msg(sudo_id, "`این دستور را با یک پیام متنی، فیلم، عکس، موسیقی و... ریپلی کنید.`", true)
		end
	elseif msg.text == "/groups" and msg.chat.id == sudo_id then
		local list = ""
		i=0
		for k,v in pairs(groups) do
			i=i+1
			list = list..i..") "..k.."\n"
		end
		return send_msg(sudo_id, "لیست گروها:\n\n"..list, true)
	elseif msg.text == '/sendtoallpv' and msg.chat.id == sudo_id then
		if msg.reply_to_message then
			send_msg(sudo_id, "منتظر بمانید...", true)
			i=0
			for k,v in pairs(users) do
				i=i+1
				send_fwrd(k, msg.reply_to_message.from.id, msg.reply_to_message.message_id)
			end
			return send_msg(sudo_id, "`پیام شما به "..i.." نفر ارسال شد`", true)
		else
			return send_msg(sudo_id, "`این دستور را با یک پیام متنی، فیلم، عکس، موسیقی و... ریپلی کنید.`", true)
		end
	elseif msg.text == "/users" and msg.chat.id == sudo_id then
		local list = ""
		i=0
		for k,v in pairs(users) do
			i=i+1
			if users[k].username then
				uz = " - @"..users[k].username
			else
				uz = ""
			end
			list = list..i.."- "..k..uz.."\n"
		end
		return send_msg(sudo_id, "لیست اعضا:\n\n"..list, false)
	elseif msg.text == "/blocklist" and msg.from.id == sudo_id then
		local list = ""
		i=0
		for k,v in pairs(blocks) do
			if v then
				i=i+1
				list = list..i.."- "..k.."\n"
			end
		end
		return send_msg(sudo_id, "بلاک لیست:\n\n"..list, false)
	elseif msg.text:find('/block') and msg.chat.id == sudo_id then
		local usertarget = msg.text:input()
		if usertarget then
			if tonumber(usertarget) == sudo_id or tonumber(usertarget) == bot.id then
				return send_msg(sudo_id, "`نمیتوانید خودتان را بلاک کنید`", true)
			end
			if blocks[tostring(usertarget)] then
				return send_msg(sudo_id, "`شخص مورد نظر بلاک است`", true)
			end
			blocks[tostring(usertarget)] = true
			save_data("blocks.json", blocks)
			send_msg(tonumber(usertarget), "`شما بلاک شدید!`", true)
			return send_msg(sudo_id, "`شخص مورد نظر بلاک شد`", true)
		else
			return send_msg(sudo_id, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`", true)
		end
	elseif msg.text:find('/unblock') and msg.chat.id == sudo_id then
		local usertarget = msg.text:input()
		if usertarget then
			if blocks[tostring(usertarget)] then
				blocks[tostring(usertarget)] = false
				save_data("blocks.json", blocks)
				send_msg(tonumber(usertarget), "`شما آنبلاک شدید!`", true)
				return send_msg(sudo_id, "`شخص مورد نظر آنبلاک شد`", true)
			end
			return send_msg(sudo_id, "`شخص مورد نظر بلاک نیست`", true)
		else
			return send_msg(sudo_id, "`بعد از این دستور آی دی شخص مورد نظر را با درج یک فاصله وارد کنید`", true)
		end
	end
	
	if msg.text == "لغو" or msg.text == "منو" or msg.text:lower() == "/update" then
		users[userid].action = 0
		save_data("users.json", users)
		return send_key(msg.from.id, "`کلید مورد نظر را انتخاب نمایید:`", keyboard)
	elseif msg.text == "ایجاد متن با فونتهای مختلف و هایپر لینک" then
		users[userid].action = 1
		save_data("users.json", users)
		return send_key(msg.from.id, "از این طریق میتوانید متون خود را با فونتهای مختلف (قابلیت مارک داون) و قرار دادن لینک روی متن (هایپر لینک) ایجاد کنید.\n\n`برای کلفت نویسی، متن مورد نظر را بین 2 عدد * قرار دهید. دقت کنید این قابلیت مربوط به حروف انگلیسی است. مثال:\n*`tgMember`* =` *tgMember*\n\n`برای کج نویسی، متن مورد نظر را بین 2 عدد _ قرار دهید. دقت کنید این قابلیت مربوط به حروف انگلیسی است. مثال:\n_`tgMember`_ = `_tgMember_\n\n*برای ماشین نویسی یا نوشتن با حالت کدینگ، متن مورد نظر را بین 2 عدد ` قرار دهید. از این حالت میتوانید در حروف فارسی و انگلیسی بهره ببرید. مثال:\n`*tgMember*`=*  `tgMember`\n\n`برای قراردادن لینک روی متن و هایپر لینک، متن مورد نظر را بین [] قرار دهید و لینک مورد نظر را نیز بین () بگذارید. مثال:\n[tgMember](telegram.me/tgMember)` = [tgMember](telegram.me/tgMember)\n\nمتن خود را طبق فرمول گفته شده ارسال کنید:", {{"لغو"}}, true)
	elseif msg.text == "ارسال کیبرد شیشه ای به کانال" then
		users[userid].action = 2
		save_data("users.json", users)
		return send_key(msg.from.id, '`متنی را حداکثر تا 4000 کاراکتر وارد کنید. قابلت مارک داون که در بخش "ایجاد متن با فونتهای مختلف و هایپر لینک" توضیح داده شد نیز فعال است و میتوانید از فرمول های آن نیز استفاده کنید. دقت کنید که کیلیدهای شیشه ای زیر این متن نمایش داده میشوند پس این متن اصلی میباشد.`', {{"لغو"},{"مثال کیبرد اینلاین"}}, true)
	elseif msg.text == "نگهبان گروه و ضد تبلیغ" then
		users[userid].action = 0
		save_data("users.json", users)
		gp_in_txt = "با افزودن این ربات به گروه خود میتوانید افرادی که در گروه تبلیغ میکنند را به صورت اتوماتیک حذف کنید یا فقط به آنان اخطار دهید. همچنین میتوانید پیام خوش آمد گویی برای گروه ثبت نمایید که به محض ورود هر شخص، متن نمایان شود همچنین میتوانید قوانین برای گروه نصب کنید. دقت کنید که به محض افزودن ربات به گروه، باید ربات را نیز مدیر گروه قرار دهید و بعد از آن، همه ی مدیران گروه، مدیر ربات نیز میشوند و میتوانند تنظیمات را تغییر دهند. این ربات در گروه کارایی های دیگر هم دارد."
		return send_inline(msg.from.id, gp_in_txt, add_key)
	elseif msg.text == "درج زیرنویس در عکس، فیلم، گیف و فایل" then
		users[userid].action = 4
		save_data("users.json", users)
		return send_key(msg.from.id, "`يک عکس، ويدئو، گيف یا فايل فوروارد یا ارسال نماييد. حداکثر حجم مجاز 50 مگابايت ميباشد.`", {{"لغو"}}, true)
	elseif msg.text == "مثال کیبرد اینلاین" then
		return send_inline(msg.from.id, "`تیتر کیبرد اینلاین با قابلیت استفاده از قابلیت مارک داون و هایپر لینک.`", {{text = "کانال تلگرام ممبر" , url = "https://telegram.me/tgMember"}},{{{text = "وبسایت تیم تلگرام ممبر" , url = "http://tgMember.cf"}}})
	end
	
	if users[userid].action == 0 then
		return send_key(msg.from.id, "`ورودی صحیح نیست، یک گزینه دیگر را انتخاب کنید.`", keyboard)
	elseif users[userid].action == 1 then
		users[userid].action = 0
		save_data("users.json", users)
		send_msg(msg.from.id, msg.text, true)
		return send_key(msg.from.id, "اگر فرمول را درست وارد کرده باشید و از علامت ها ` و _ و * و ( و ) و [ و ] به صورت تکی و خارج از چهار چوب استفاده نکرده باشید، متن شم در زیر ساخته و ارسال خواهد شد.", keyboard, false, true)
	elseif users[userid].action == 2 then
		if string.len(msg.text) > 4000 then
			return send_key(msg.from.id, "`متن وارد شده بیش از 4000 کاراکتر میباشد، متن را اصلاح نمایید`", {{"لغو"}}, true)
		end
		users[userid].titr = msg.text
		users[userid].action = 20
		save_data("users.json", users)
		return send_key(msg.from.id, "`تعداد کلیدهای کیبرد شیشه ای را وارد نمایید. حداکثر 20 عدد مجاز است.`", {{"لغو"}}, true)
	elseif users[userid].action == 20 then
		if not string.match(msg.text, '^%d+$') then
			return send_msg(msg.from.id, "`عددی بین 1 تا 20 وارد کنید.`", true)
		end
		if tonumber(msg.text) > 20 then
			return send_msg(msg.from.id, "`تعداد کلیدهای مجاز حداکثر 20 عدد میباشد، اصلاح کنید.`", true)
		end
		if tonumber(msg.text) < 1 then
			return send_msg(msg.from.id, "`حداقل کلیدها باید 1 عدد باشد.`", true)
		end
		users[userid].action = 21
		users[userid].tab = tonumber(msg.text)
		users[userid].tables = ""
		save_data("users.json", users)
		return send_key(msg.from.id, "`متن کلید `"..msg.text.."` را تا حداکثر 50 کاراکتر وارد نمایید.`", {{"لغو"}}, true)
	elseif users[userid].action == 21 then
		if string.len(msg.text) > 50 then
			return send_msg(msg.from.id, "`متن وارد شده بیش از 50 کاراکتر میباشد، متن را اصلاح نمایید`", true)
		end
		users[userid].action = 22
		users[userid].tabtxt = msg.text
		save_data("users.json", users)
		return send_msg(msg.from.id, "`لینکی که میخواهید این کلید نماینده ی آن باشد را وارد کنید\nمثال: https://telegram.me/tgMember`", true)
	elseif users[userid].action == 22 then
		if users[userid].tables == "" then
			tabtab = ""
		else
			tabtab = users[userid].tables..","
		end
		users[userid].tables = tabtab..'[{"text":"'..users[userid].tabtxt..'","url":"'..msg.text..'"}]'
		if users[userid].tab == 1 then
			hashid = userid..os.date("%F%H%M%S")
			channels[tostring(hashid)] = {}
			channels[tostring(hashid)].title = users[userid].titr
			channels[tostring(hashid)].tables = users[userid].tables
			save_data("channels.json", channels)
			users[userid].action = 0
			save_data("users.json", users)
			send_msg(msg.from.id, "`@tgGuardbot "..hashid.."`", true)
			return send_key(msg.from.id, "`کیبرد شیشه ای ساخته شد، متن زیر را در محل تایپ وارد نمایید و منتظر بمانید تا کلید ارسال ظاهر شود، با کلیک روی کلید کیبرد شما به محل مورد نظر ارسال میگردد. دقت کنید این کد را به دفعات مختلف میتوانید استفاده کنید و اطلاعات آن در دیتا بیس میماند.`", keyboard)
		else
			users[userid].tab = users[userid].tab-1
			users[userid].action = 21
			save_data("users.json", users)
			return send_key(msg.from.id, "`متن کلید `"..users[userid].tab.."` را تا حداکثر 50 کاراکتر وارد نمایید.`", {{"لغو"}}, true)
		end
	elseif users[userid].action == 4 then
		if msg.document then
			users[userid].file_type = "document"
			users[userid].file_id = msg.document.file_id
		elseif msg.video then
			users[userid].file_type = "video"
			users[userid].file_id = msg.video.file_id
		elseif msg.photo then
			i = #msg.photo
			users[userid].file_type = "photo"
			users[userid].file_id = msg.photo[i].file_id
		else
			return send_msg(msg.from.id, "`فقط قادر به ارسال عکس، ويدئو، گيف و فايل ميباشيد. حداکثر حجم مجاز 50 مگابايت ميباشد.`", true)
		end
		users[userid].action = 40
		save_data("users.json", users)
		return send_key(msg.from.id, "`يکي از آيتم ها را انتخاب نماييد`", {{"لغو"},{"وارد کردن زيرنويس"},{"ارسال بدون زيرنويس"}}, true)
	elseif users[userid].action == 40 then
		if msg.text == "وارد کردن زيرنويس" then
			users[userid].action = 41
			save_data("users.json", users)
			return send_key(msg.from.id, "`متن مورد نظر را وارد کنيد، دقت کنيد که متن وارد شده کمتر از 300 کاراکتر باشد و در آن از فرمولهاي مارک داون استفده نشود.`", {{"لغو"}}, true)
		elseif msg.text == "ارسال بدون زيرنويس" then
			if users[userid].file_type == "document" then
				send_doc(msg.from.id, users[userid].file_id, false)
			elseif users[userid].file_type == "video" then
				send_video(msg.from.id, users[userid].file_id, false)
			elseif users[userid].file_type == "photo" then
				send_photo(msg.from.id, users[userid].file_id, false)
			end
		else
			return send_msg(msg.from.id, "`ورودي صحيح نيست.`", true)
		end
		users[userid].action = 0
		save_data("users.json", users)
		return send_key(msg.from.id, "`عمليات مورد نظر انجام شد.`", keyboard)
	elseif users[userid].action == 41 then
		if not msg.text then
			return send_msg(msg.from.id, "`فقط قادر به ارسال متن میباشید.`", true)
		end
		if string.len(msg.text) > 300 then
			return send_msg(msg.from.id, "`متن وارد شده بیش از 300 کاراکتر میباشد، متن را اصلاح نمایید`", true)
		end
		if users[userid].file_type == "document" then
			send_doc(msg.from.id, users[userid].file_id, msg.text)
		elseif users[userid].file_type == "video" then
			send_video(msg.from.id, users[userid].file_id, msg.text)
		elseif users[userid].file_type == "photo" then
			send_photo(msg.from.id, users[userid].file_id, msg.text)
		end
		users[userid].action = 0
		save_data("users.json", users)
		return send_key(msg.from.id, "`عملیات مورد نظر انجام شد.`", keyboard)
	end
end

function inline(msg)
	tab1 = '{"type":"article","parse_mode":"Markdown","disable_web_page_preview":true,"id":'
	thumb = "http://umbrella.shayan-soft.ir/inline_icons/"
	if msg.query == "" or msg.query == nil then
		tab_inline = tab1..'"1","title":"کد را وارد کنید","description":"کد کیبردی که قبلا ساخته اید را وارد کنید یا همینک آن را بسازید","message_text":"جهت ساخت کیبرد به پی وی ربات مراجعه کنید\n@tgGuardbot","thumb_url":"'..thumb..'ltd.png"}'
	else
		channels = load_data("channels.json")
		if channels[tostring(msg.query)] then
			tabless = channels[tostring(msg.query)].tables:gsub("\\","")
			tab_inline = tab1..'"2","title":"ارسال کیبرد","description":"جهت ارسال کیبرد اینجا کلیک کنید","message_text":"'..channels[tostring(msg.query)].title..'","thumb_url":"'..thumb..'keyk_ok.png","reply_markup":{"inline_keyboard":['..tabless..']}}'
		else
			tab_inline = tab1..'"3","title":"کد صحیح نیست","description":"کد کیبرد وارد شده صحیح نیست، برای ساخت کلیک کنید","message_text":"جهت ساخت کیبرد به پی وی ربات مراجعه کنید\n@tgGuardbot","thumb_url":"'..thumb..'ltder.png"}'
		end
	end
	return send_req(send_api.."/answerInlineQuery?inline_query_id="..msg.id.."&is_personal=true&cache_time=1&results="..url.escape('['..tab_inline..']'))
end

return {launch = run , inline = inline}