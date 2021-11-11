﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ПереходНаФСБУ25 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеЗаполнения, "ПереходНаФСБУ25", Ложь);
	КонецЕсли;
	НачалоПримененияФСБУ25 = УчетнаяПолитика.НачалоПримененияФСБУ25(Организация);
	Если ПереходНаФСБУ25 Тогда
		Дата = НачалоДня(НачалоПримененияФСБУ25 - 1);
	Иначе
		ПереходНаФСБУ25 = КонецДня(Дата) = НачалоПримененияФСБУ25 - 1;
	КонецЕсли;
	ПрименяетсяФСБУ25 = Дата >= НачалоПримененияФСБУ25;
	
	Если Не ЗначениеЗаполнено(ВидОперации) Тогда
		Если Не ПрименяетсяФСБУ25 И Не ПереходНаФСБУ25 Тогда
			ВидОперации = Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВЛизинг;
		Иначе
			ВидОперации = ?(ПолучитьФункциональнуюОпцию("ВедетсяУчетЛизинговогоИмущества"),
				Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВЛизинг,
				Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВАренду);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПрименяетсяФСБУ25 Тогда
		НалоговыйУчетИмуществаВедетЛизингополучатель = Истина;
	КонецЕсли;
	
	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата);
	
	Если Не ПолучитьФункциональнуюОпцию("РасширенныйФункционал")
		Или Не ПлательщикНалогаНаПрибыль Тогда
		СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РавнаСуммеДоговора;
	ИначеЕсли ПереходНаФСБУ25 Тогда
		СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РассчитываетсяПоСтавке;
	ИначеЕсли Не ПрименяетсяФСБУ25 Тогда
		СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РавнаСуммеДоговора;
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВЛизинг Тогда
		СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РавнаРасходамЛизингодателя;
	Иначе
		СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РассчитываетсяПоСтавке;
	КонецЕсли;
	
	ПринятьКУчету = Истина;
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДоговорКонтрагента, "Валютный,РасчетыВУсловныхЕдиницах");
	Иначе
		РеквизитыДоговора = Новый Структура("Валютный,РасчетыВУсловныхЕдиницах", Ложь, Ложь);
	КонецЕсли;
	Если РеквизитыДоговора.РасчетыВУсловныхЕдиницах Тогда
		СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.АрендныеОбязательстваУЕ;
	ИначеЕсли РеквизитыДоговора.Валютный Тогда
		СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.АрендныеОбязательстваВал;
	Иначе
		СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.АрендныеОбязательства;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
	
	ПредметыЛизинга.Очистить();
	ЛизингДоФСБУ25 = Ложь;
	ПереходНаФСБУ25 = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;
	
	ЭтоЛизингДоФСБУ25 = ЛизингДоФСБУ25
		Или Не ЗначениеЗаполнено(ВидОперации) 
		И Не ЗначениеЗаполнено(СпособОценкиАрендыБУ);
	
	Если ЭтоЛизингДоФСБУ25 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидОперации");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончанияАренды");
		МассивНепроверяемыхРеквизитов.Добавить("СпособОценкиАрендыБУ");
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаДисконтирования");
		МассивНепроверяемыхРеквизитов.Добавить("СпособОтраженияРасходовПоАмортизации");
		МассивНепроверяемыхРеквизитов.Добавить("СпособОтраженияРасходовПоАренднымПлатежам");
		
		МассивНепроверяемыхРеквизитов.Добавить("ГрафикПлатежей");
		МассивНепроверяемыхРеквизитов.Добавить("ГрафикПлатежей.ДатаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("ГрафикПлатежей.СуммаПлатежа");
		
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.ПредметАренды");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.Сумма");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.РасходыЛизингодателя");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.СтоимостьБУ");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.СчетНачисленияАмортизации");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.СчетУчетаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.СрокПолезногоИспользования");
		
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыЛизинга.СчетУчетаНДС");
		Для Каждого СтрокаТаблицы Из ПредметыЛизинга Цикл 
			Префикс = "ПредметыЛизинга[%1].";
			Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Префикс, Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ="));
			ИмяСписка = НСтр("ru = 'Предметы лизинга'");
			
			Если СтрокаТаблицы.СуммаНДС <> 0 
				И НЕ ЗначениеЗаполнено(СтрокаТаблицы.СчетУчетаНДС) Тогда
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Счет НДС'"),
					СтрокаТаблицы.НомерСтроки, ИмяСписка);
				Поле = Префикс + "СчетУчетаНДС";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыЛизинга");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыЛизинга.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыЛизинга.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыЛизинга.Сумма");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыЛизинга.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыЛизинга.СчетУчета");
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыЛизинга.СчетУчетаНДС");
		
		Если СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РавнаСуммеДоговора Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СтавкаДисконтирования");
			МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.ОценкаБУ");
			МассивНепроверяемыхРеквизитов.Добавить("ГрафикПлатежей");
			МассивНепроверяемыхРеквизитов.Добавить("ГрафикПлатежей.ДатаПлатежа");
			МассивНепроверяемыхРеквизитов.Добавить("ГрафикПлатежей.СуммаПлатежа");
		ИначеЕсли СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РавнаРасходамЛизингодателя Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СтавкаДисконтирования");
			МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.ОценкаБУ");
		ИначеЕсли СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РассчитываетсяПоСтавке Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.ОценкаБУ");
		ИначеЕсли СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.УказываетсяВручную Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СтавкаДисконтирования");
		КонецЕсли;
		
		ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата);
		Если Не ПлательщикНалогаНаПрибыль Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СпособОтраженияРасходовПоАренднымПлатежам");
		КонецЕсли;
		Если Не (ПлательщикНалогаНаПрибыль 
			И ВидОперации = Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВЛизинг 
			И НалоговыйУчетИмуществаВедетЛизингополучатель) 
			И СпособОценкиАрендыБУ <> Перечисления.СпособыОценкиБУ.РавнаРасходамЛизингодателя 
			Или ПереходНаФСБУ25 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.РасходыЛизингодателя");
		КонецЕсли;
		
		Если ВидОперации <> Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВЛизинг Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.СрокПолезногоИспользования");
		КонецЕсли;
		
		Если Не ПринятьКУчету Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СпособОтраженияРасходовПоАмортизации");
			МассивНепроверяемыхРеквизитов.Добавить("СпособОтраженияРасходовПоАренднымПлатежам");
			МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.СчетНачисленияАмортизации");
			МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.СрокПолезногоИспользования");
		КонецЕсли;
		
		УправлениеВнеоборотнымиАктивами.ПроверитьОтсутствиеДублейВТабличнойЧасти(
			ЭтотОбъект, "ПредметыАренды", Новый Структура("ПредметАренды"), Отказ);
		
		МассивНепроверяемыхРеквизитов.Добавить("ПредметыАренды.СчетУчетаНДС");
		Если Не НДСВключенВСтоимость Тогда
			Для Каждого СтрокаТаблицы Из ПредметыАренды Цикл 
				Префикс = "ПредметыАренды[%1].";
				Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					Префикс, Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ="));
				ИмяСписка = НСтр("ru = 'Предметы аренды'");
				
				Если СтрокаТаблицы.СуммаНДС <> 0 
					И НЕ ЗначениеЗаполнено(СтрокаТаблицы.СчетУчетаНДС) Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Счет НДС'"),
						СтрокаТаблицы.НомерСтроки, ИмяСписка);
					Поле = Префикс + "СчетУчетаНДС";
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ПроверятьОценкуБУ = МассивНепроверяемыхРеквизитов.Найти("ПредметыАренды.ОценкаБУ") = Неопределено
			И Не ПереходНаФСБУ25;
		ПроверятьСправедливуюСтоимость = ПереходНаФСБУ25 
			И ВидОперации = Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВЛизинг;
		ПроверятьРасходыЛизингодателя = 
			МассивНепроверяемыхРеквизитов.Найти("ПредметыАренды.РасходыЛизингодателя") = Неопределено;
		Если ПроверятьОценкуБУ Или ПроверятьСправедливуюСтоимость Или ПроверятьРасходыЛизингодателя Тогда
			Для каждого СтрокаТаблицы Из ПредметыАренды Цикл
				
				Префикс = "ПредметыАренды[%1].";
				Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					Префикс, Формат(СтрокаТаблицы.НомерСтроки - 1, "ЧН=0; ЧГ="));
				ИмяСписка = НСтр("ru = 'Предметы аренды'");
				
				Если СуммаВключаетНДС И Не НДСВключенВСтоимость Тогда
					СуммаДоговора = СтрокаТаблицы.Сумма - СтрокаТаблицы.СуммаНДС;
				ИначеЕсли Не СуммаВключаетНДС И НДСВключенВСтоимость Тогда
					СуммаДоговора = СтрокаТаблицы.Сумма + СтрокаТаблицы.СуммаНДС;
				Иначе
					СуммаДоговора = СтрокаТаблицы.Сумма;
				КонецЕсли;
				
				Если ПроверятьРасходыЛизингодателя 
					И СуммаДоговора <= СтрокаТаблицы.РасходыЛизингодателя Тогда
					Поле = Префикс + "РасходыЛизингодателя";
					ИмяПоля = НСтр("ru = 'Расходы лизингодателя'");
					ТекстОшибки = НСтр("ru='Расходы лизингодателя должны быть меньше суммы по договору.'");
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
						"Колонка", "Корректность", ИмяПоля, СтрокаТаблицы.НомерСтроки, ИмяСписка, ТекстОшибки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;
				Если ПроверятьОценкуБУ 
					И СуммаДоговора <= СтрокаТаблицы.ОценкаБУ Тогда
					Поле = Префикс + "ОценкаБУ";
					ИмяПоля = НСтр("ru = 'Оценка в БУ'");
					ТекстОшибки = НСтр("ru='Оценка в БУ должна быть меньше суммы по договору.'");
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
						"Колонка", "Корректность", ИмяПоля, СтрокаТаблицы.НомерСтроки, ИмяСписка, ТекстОшибки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;
				Если ПроверятьСправедливуюСтоимость 
					И СтрокаТаблицы.ОценкаБУ = 0 Тогда
					Поле = Префикс + "ОценкаБУ";
					ИмяПоля = НСтр("ru = 'Справедливая стоимость'");
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
						"Колонка", "Заполнение", ИмяПоля, СтрокаТаблицы.НомерСтроки, ИмяСписка, ТекстОшибки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаОкончанияАренды) И НачалоМесяца(ДатаОкончанияАренды) <= НачалоМесяца(Дата) Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru='Дата окончания аренды должна быть не ранее %1.'"),
				Формат(КонецМесяца(Дата) + 1, "ДЛФ=D"));
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаОкончанияАренды", "Объект", Отказ);
		КонецЕсли;
		
		Если СпособОценкиАрендыБУ <> Перечисления.СпособыОценкиБУ.РавнаСуммеДоговора Тогда
			ИтогСуммаПлатежа = ГрафикПлатежей.Итог("СуммаПлатежа");
			ИтогСуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
			Если ИтогСуммаПлатежа <> 0 И ИтогСуммаДокумента <> 0 И ИтогСуммаПлатежа <> ИтогСуммаДокумента Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru='Сумма по графику платежей (%1) отличается от суммы документа (%2).'"),
					Формат(ИтогСуммаПлатежа, "ЧДЦ=2"), Формат(ИтогСуммаДокумента, "ЧДЦ=2"));
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , "Объект", Отказ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
	
	Если Не ПринятьКУчету Тогда
		МОЛ = Неопределено;
		СпособОтраженияРасходовПоАмортизации = Неопределено;
		СпособОтраженияРасходовПоАренднымПлатежам = Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидОперации)
		И Не ЗначениеЗаполнено(СпособОценкиАрендыБУ) Тогда
		ЛизингДоФСБУ25 = Истина;
		ВидОперации = Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВЛизинг;
		НалоговыйУчетИмуществаВедетЛизингополучатель = Истина;
		СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РавнаСуммеДоговора;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВАренду Тогда
		НалоговыйУчетИмуществаВедетЛизингополучатель = Ложь;
	КонецЕсли;
	
	// Все, связанное с дисконтированием обязательства, 
	// выполняется только с опцией РасширенныйФункционал (в версии КОРП)
	
	Если Не ПолучитьФункциональнуюОпцию("РасширенныйФункционал") Тогда
		СпособОценкиАрендыБУ = Перечисления.СпособыОценкиБУ.РавнаСуммеДоговора;
	КонецЕсли;
	
	УчетПроцентовПоОбязательствам.ЗаполнитьДанныеДисконтированияОбязательстваПоАренде(
		ЭтотОбъект, Отказ, РежимЗаписи, ПереходНаФСБУ25);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Документы по переходу на ФСБУ 25 не сбивают последовательность, а делают неактуальной рег.операцию
	Если ПереходНаФСБУ25 
		И (Проведен Или ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Запись) Тогда
		
		ДополнительныеСвойства.Вставить("НеИзменятьРегистрациюВПоследовательности", Истина);
		УстаревшаяРегламентнаяОперация = Перечисления.ВидыРегламентныхОпераций.ПереходНаФСБУ25;
		НомерГруппы = ЗакрытиеМесяца.ГруппаПоВидуОперации(УстаревшаяРегламентнаяОперация);
		РегистрыСведений.НеактуальныеРегламентныеОперации.СдвинутьГраницуАктуальностиНазад(
			Организация,
			Дата,
			НомерГруппы,
			УстаревшаяРегламентнаяОперация,
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	УчетУЛизингополучателя = ВидОперации = Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВЛизинг
		И НалоговыйУчетИмуществаВедетЛизингополучатель;
	
	Если Не УчетУЛизингополучателя Тогда
		НачалоПримененияФСБУ25 = УчетнаяПолитика.НачалоПримененияФСБУ25(Организация);
		ДатаПереходаНаФСБУ25 = НачалоДня(НачалоПримененияФСБУ25 - 1);
		Если Дата < ДатаПереходаНаФСБУ25
			Или НачалоДня(Дата) = ДатаПереходаНаФСБУ25 И Не ПереходНаФСБУ25 Тогда
			ТекстШаблона = ?(ВидОперации = Перечисления.ВидыОперацийПоступлениеВАренду.ПоступлениеВЛизинг,
				НСтр("ru='Поступление в лизинг с учетом у лизингодателя не может быть оформлено раньше %1 - начала применения ФСБУ 25.'"),
				НСтр("ru='Поступление в аренду не может быть оформлено раньше %1 - начала применения ФСБУ 25.'"));
			ТекстОшибки = СтрШаблон(ТекстШаблона, Формат(НачалоПримененияФСБУ25, "ДЛФ=D"));
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "Дата", , Отказ);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ПоступлениеВАренду.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыПоступление = ПараметрыПроведения.РеквизитыПоступление;
	
	Если Не ЛизингДоФСБУ25 Тогда
		
		// Документы с поддержкой ФСБУ 25
		
		// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ (АНАЛИЗ ОСТАТКОВ И Т.П.)
		
		ТаблицаПредметыАренды = ПараметрыПроведения.ТаблицаПредметыАренды;
		ТаблицаПредметыАрендыПроводки = ПараметрыПроведения.ТаблицаПредметыАрендыПроводки;
		ТаблицаПринятиеКУчетуПроводки = ПараметрыПроведения.ТаблицаПринятиеКУчетуПроводки;
		РеквизитыПринятиеКУчетуПроводки = ПараметрыПроведения.РеквизитыПринятиеКУчетуПроводки;
		ТаблицаПринятиеКУчетуРегистрыБУ = ПараметрыПроведения.ТаблицаПринятиеКУчетуРегистрыБУ;
		РеквизитыПринятиеКУчетуРегистрыБУ = ПараметрыПроведения.РеквизитыПринятиеКУчетуРегистрыБУ;
		ТаблицаПринятиеКУчетуРегистрыНУ = ПараметрыПроведения.ТаблицаПринятиеКУчетуРегистрыНУ;
		РеквизитыПринятиеКУчетуРегистрыНУ = ПараметрыПроведения.РеквизитыПринятиеКУчетуРегистрыНУ;
		
		Если ПереходНаФСБУ25 И УчетУЛизингополучателя Тогда
			УчетОС.ПроверитьСостояниеОСПринятоКУчету(
				ТаблицаПредметыАренды, РеквизитыПоступление, Отказ);
		Иначе
			УчетОС.ПроверитьВозможностьИзмененияСостоянияОС(
				ТаблицаПредметыАренды, РеквизитыПринятиеКУчетуРегистрыБУ, Отказ);
		КонецЕсли;
		
		ТаблицаГрафикПроцентов = Документы.ПоступлениеВАренду.ГрафикПроцентовПоАренде(
			ПараметрыПроведения.ТаблицаГрафикПлатежей, ТаблицаПредметыАренды, РеквизитыПоступление);
			
		ТаблицаКорректировкаЛизинга = Документы.ПоступлениеВАренду.ТаблицаКорректировкаЛизингаПараметрыАмортизацииБУ(
			ТаблицаПредметыАренды, РеквизитыПоступление);
		
		// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
		
		// Проводки по всем документам перехода на ФСБУ 25 формируются регламентной операцией вида ПереходНаФСБУ25.
		ФормироватьПроводки = Не ПереходНаФСБУ25;
		
		Если ФормироватьПроводки Тогда
			
			Документы.ПоступлениеВАренду.ДобавитьКолонкуСодержание(ТаблицаПредметыАрендыПроводки, РеквизитыПоступление);
			
			// Поступление предметов аренды - проводки
			УчетОС.СформироватьДвиженияПоступлениеПредметыАренды(
				ТаблицаПредметыАрендыПроводки, РеквизитыПоступление, Движения, Отказ);
			
			// Принятие к учету предметов аренды - проводки
			УчетОС.СформироватьДвиженияПринятиеКУчетуОСПредметыАренды(
				ТаблицаПринятиеКУчетуПроводки, РеквизитыПринятиеКУчетуПроводки, Движения, Отказ);
			
			// Проценты по аренде - проводки
			УчетПроцентовПоОбязательствам.СформироватьДвиженияПоступлениеПроцентыПоАренде(
				ТаблицаПредметыАренды, РеквизитыПоступление, Движения, Отказ);
			
			// НДС - проводки
			УчетНДС.СформироватьДвиженияПоступлениеВАренду(
				ТаблицаПредметыАрендыПроводки, РеквизитыПоступление, Движения, Отказ);
			
		КонецЕсли;
		
		// Данные предметов аренды - служебный регистр
		УчетОС.СформироватьДвиженияДанныеОПоступленииПредметыАренды(
			ТаблицаПредметыАренды, РеквизитыПоступление, Движения, Отказ);
		
		// Принятие к учету предметов аренды - регистры учета ОС, БУ
		УчетОС.СформироватьДвиженияПредметыАрендыПоступлениеСПринятиемКУчетуБУ(
			ТаблицаПринятиеКУчетуРегистрыБУ, РеквизитыПринятиеКУчетуРегистрыБУ, Движения, Отказ);
		
		// Изменение параметров амортизации БУ при переходе на ФСБУ 25 для "старого" лизинга
		УчетОС.СформироватьДвиженияИзмененияПараметровАмортизацииОСБУ(
			ТаблицаКорректировкаЛизинга, РеквизитыПринятиеКУчетуРегистрыБУ, Движения, Отказ);
		
		// Принятие к учету предметов аренды - регистры учета ОС, НУ
		УчетОС.СформироватьДвиженияПредметыАрендыПоступлениеСПринятиемКУчетуНУ(
			ТаблицаПринятиеКУчетуРегистрыНУ, РеквизитыПринятиеКУчетуРегистрыНУ, Движения, Отказ);
		
		// График будущих процентных расходов
		УчетПроцентовПоОбязательствам.СформироватьДвиженияГрафикиПроцентныхРасходов(
			ТаблицаГрафикПроцентов, РеквизитыПоступление, Движения, Отказ);
		
		//Движения регистра "Рублевые суммы документов в валюте"
		УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалютеПоступлениеСобственныхТоваровУслуг(
			ПараметрыПроведения.ТаблицаРублевыеСуммыДокументовВВалюте, РеквизитыПоступление, Движения, Отказ);
		
	Иначе
		
		// Старые документы без поддержки ФСБУ 25
		
		// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ (АНАЛИЗ ОСТАТКОВ И Т.П.)
		
		// Таблица взаиморасчетов
		ТаблицаВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
			ПараметрыПроведения.ЗачетАвансовТаблицаДокумента,
			ПараметрыПроведения.ЗачетАвансовТаблицаАвансов, 
			ПараметрыПроведения.ЗачетАвансовРеквизиты,
			Отказ);
		
		// Таблицы документа с корректировкой сумм по курсу авансов
		СтруктураТаблицДокумента = УчетДоходовРасходов.ПодготовитьТаблицыПоступленияПоКурсуАвансов(
			ПараметрыПроведения.СтруктураТаблицДокумента,
			ТаблицаВзаиморасчеты, 
			ПараметрыПроведения.ЗачетАвансовРеквизиты);
		
		ТаблицаПредметыЛизинга = СтруктураТаблицДокумента.ТаблицаПредметыЛизинга;
		Документы.ПоступлениеВАренду.ДобавитьКолонкуСодержание(ТаблицаПредметыЛизинга, РеквизитыПоступление);
		
		// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
		
		// Поступление предметов лизинга
		УчетОС.СформироватьДвиженияПоступлениеПредметыЛизингаДоФСБУ25(
			ТаблицаПредметыЛизинга, РеквизитыПоступление, Движения, Отказ);
		
		//Движения регистра "Рублевые суммы документов в валюте"
		УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалютеПоступлениеСобственныхТоваровУслуг(
			ТаблицаПредметыЛизинга, РеквизитыПоступление, Движения, Отказ);
		
		// Учет НДС
		УчетНДС.СформироватьДвиженияПоступлениеПредметовЛизингаОтПоставщика(
			ТаблицаПредметыЛизинга, РеквизитыПоступление, Движения, Отказ);
		
		УчетНДСРаздельный.СформироватьДвиженияПоступлениеПредметовЛизингаОтПоставщика(
			ТаблицаПредметыЛизинга, РеквизитыПоступление, Движения, Отказ);
		
	КонецЕсли;
	
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.ПереоценкаВалютныхОстатковРеквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.ПереоценкаВалютныхОстатковРеквизиты, Движения, Отказ);
	
	УчетУСН.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.ПереоценкаВалютныхОстатковРеквизиты, Движения, Отказ);
	
	Движения.Хозрасчетный.ЗаполнитьСуммыВременныхРазниц();
	
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли