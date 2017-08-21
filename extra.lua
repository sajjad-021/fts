function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function send_inline(chat_id, text, keyboard, mark)
	local response = {}
	response.inline_keyboard = keyboard
	local responseString = json.encode(response)
	if mark then
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	else
		sended = send_api.."/sendMessage?chat_id="..chat_id.."&text="..url.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..url.escape(responseString)
	end
	return send_req(sended)
end

function send_photo(chat_id, photo, caption)
	if caption then
		send = send_api.."/sendPhoto?chat_id="..chat_id.."&photo="..photo.."&caption="..url.escape(caption)
	else
		send = send_api.."/sendPhoto?chat_id="..chat_id.."&photo="..photo
	end
	return send_req(send)
end

function send_video(chat_id, video, caption)
	if caption then
		send = send_api.."/sendVideo?chat_id="..chat_id.."&video="..video.."&caption="..url.escape(caption)
	else
		send = send_api.."/sendVideo?chat_id="..chat_id.."&video="..video
	end
	return send_req(send)
end

function send_doc(chat_id, document, caption)
	if caption then
		send = send_api.."/sendDocument?chat_id="..chat_id.."&document="..document.."&caption="..url.escape(caption)
	else
		send = send_api.."/sendDocument?chat_id="..chat_id.."&document="..document
	end
	return send_req(send)
end

function mem_num(chat_id)
	local send = send_api.."/getChatMembersCount?chat_id="..chat_id
	return send_req(send)
end

function group(chat_id)
	local send = send_api.."/getChat?chat_id="..chat_id
	return send_req(send)
end

function admins(chat_id)
	local send = send_api.."/getChatAdministrators?chat_id="..chat_id
	return send_req(send)
end

function mem_info(chat_id, user_id)
	local send = send_api.."/getChatMember?chat_id="..chat_id.."&user_id="..user_id
	return send_req(send)
end

function kick(chat_id, user_id)
	local send = send_api.."/kickChatMember?chat_id="..chat_id.."&user_id="..user_id
	return send_req(send)
end

function leave(chat_id)
	local send = send_api.."/leaveChat?chat_id="..chat_id
	return send_req(send)
end

function send_fwrd(chat_id, from_id, msg_id)
	local urla = send_api.."/forwardMessage?chat_id="..chat_id.."&from_chat_id="..from_id.."&message_id="..msg_id
	return send_req(urla)
end