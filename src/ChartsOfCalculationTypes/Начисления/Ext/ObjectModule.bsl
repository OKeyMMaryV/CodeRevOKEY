﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности начисления по категории.
	Если КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда
		Или КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.РайонныйКоэффициент
		Или КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.СевернаяНадбавка Тогда
		Начисления = ПланыВидовРасчета.Начисления.НачисленияПоКатегории(КатегорияНачисленияИлиНеоплаченногоВремени);
		Если Начисления.Количество() > 0 И Начисления.Найти(Ссылка) = Неопределено Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Начисление с назначением ""%1"" уже существует'"),
				КатегорияНачисленияИлиНеоплаченногоВремени);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения, , "Объект.КатегорияНачисленияИлиНеоплаченногоВремени", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Прочее;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЯвляетсяДоходомВНатуральнойФорме И ВидОперацииПоЗарплате <> Перечисления.ВидыОперацийПоЗарплате.НатуральныйДоход Тогда
		ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.НатуральныйДоход;
	ИначеЕсли НЕ ЯвляетсяДоходомВНатуральнойФорме И ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.НатуральныйДоход Тогда
		Если КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛистаЗаСчетРаботодателя Тогда
			ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюРаботодатель;
		ИначеЕсли КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛиста
			Или КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускПоБеременностиИРодам Тогда
			ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСС;
		ИначеЕсли КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоПрофзаболевание
			Или КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоНесчастныйСлучайНаПроизводстве Тогда
			ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФССНС;
		Иначе
			ВидОперацииПоЗарплате = Перечисления.ВидыОперацийПоЗарплате.НачисленоДоход;
		КонецЕсли;
	КонецЕсли;
	
	ЗачетОтработанногоВремени = Не ЯвляетсяДоходомВНатуральнойФорме И
		(КатегорияНачисленияИлиНеоплаченногоВремени = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда);
		
	Если Не ЗначениеЗаполнено(КодДоходаНДФЛ) Тогда
		КатегорияДохода = Неопределено;
	ИначеЕсли Не ЗначениеЗаполнено(КатегорияДохода) Тогда
		КатегорияДохода = УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(КодДоходаНДФЛ);
	Иначе
		КодыИКатегорииНДФЛ = УчетФактическиПолученныхДоходов.СопоставлениеКодовИКатегорийДоходовНДФЛ(КодДоходаНДФЛ);
		СтруктураПоиска = Новый Структура("КодДохода", КодДоходаНДФЛ);
		Если КодДоходаНДФЛ = ПредопределенноеЗначение("Справочник.ВидыДоходовНДФЛ.Код4800") Тогда
			СтруктураПоиска.Вставить("КатегорияНачисления", КатегорияНачисленияИлиНеоплаченногоВремени);
		КонецЕсли;
		Если КодыИКатегорииНДФЛ.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			КатегорияДохода = УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(КодДоходаНДФЛ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли