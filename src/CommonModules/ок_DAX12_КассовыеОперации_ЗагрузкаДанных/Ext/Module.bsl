﻿
#Область ПрограммныйИнтерфейс

Процедура ЗагрузитьДанныеРЗ() Экспорт
	
	Параметры	=	ок_ОбщегоНазначенияФинансы21.ПолучитьПараметрыРегламентногоЗадания();
	
	Если Не Параметры = Неопределено Тогда 
		ЗагрузитьДанные(Параметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьДанные(Параметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗагрузитьТаблицу(ПолучитьИнтеграционнуюТаблицу(Параметры));
	
КонецПроцедуры

Функция ПолучитьДанные(Параметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПолучитьИнтеграционнуюТаблицу(Параметры);
	
КонецФункции

Функция ЗагрузитьТаблицу(ТаблицаЗначений) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗавершеноУспешно		=	Истина;
	
	#Область Логирование
	
	ИдентификаторОперации	=	"ок_DAX12_КассовыеОперации_ЗагрузкаДанных";
	ИдентификаторЗадания	=	Строка(Новый УникальныйИдентификатор);
	ИдентификаторПотока		=	Строка(Новый УникальныйИдентификатор);
	
	НастройкиЛогирования	=	ок_ЛогированиеОпераций.ПолучитьНастройкиЛогирования(ИдентификаторОперации);
	
	ИспользоватьЛогирование			=	НастройкиЛогирования.Использовать;
	ЗаписыватьСообщенияПользователю	=	НастройкиЛогирования.ЗаписыватьСообщенияПользователю;
	
	Если ИспользоватьЛогирование Тогда
		
		ПараметрыЛогирования	=	ок_ЛогированиеОпераций.ИнициализироватьПараметрыЛогирования();	
		
		ПараметрыЛогирования.Вставить("ИдентификаторОперации",	ИдентификаторОперации);
		ПараметрыЛогирования.Вставить("ИдентификаторЗадания",	ИдентификаторЗадания);
		ПараметрыЛогирования.Вставить("ИдентификаторПотока",	ИдентификаторПотока);
		
		ок_ЛогированиеОпераций.ЗаписастьЛогДО(ПараметрыЛогирования);
		
	КонецЕсли;
	
	#КонецОбласти
	
	Параметры	=	ПолучитьПараметры(ИспользоватьЛогирование, ЗаписыватьСообщенияПользователю, ПараметрыЛогирования);
	
	Выборка		=	Мэппинг(ТаблицаЗначений, Параметры);
	
	Пока Выборка.Следующий() Цикл
		
		#Область Логирование
		Если Параметры.ИспользоватьЛогирование Тогда
			
			ОписаниеОшибки	=	"";
			Если Выборка.НесопоставленоДоговор Тогда
				ОписаниеОшибки	=	ОписаниеОшибки	+	?(ЗначениеЗаполнено(ОписаниеОшибки), Символы.ПС, "");
				ОписаниеОшибки	=	ОписаниеОшибки	+	"Не сопоставлен договор: " + Выборка.КодДоговора;
			КонецЕсли;
			Если Выборка.НесопоставленоКонтрагент Тогда
				ОписаниеОшибки	=	ОписаниеОшибки	+	?(ЗначениеЗаполнено(ОписаниеОшибки), Символы.ПС, "");
				ОписаниеОшибки	=	ОписаниеОшибки	+	"Не сопоставлен контрагент: " + Выборка.КодКонтрагента;
			КонецЕсли;
			Если Выборка.НесопоставленоОбъект Тогда
				ОписаниеОшибки	=	ОписаниеОшибки	+	?(ЗначениеЗаполнено(ОписаниеОшибки), Символы.ПС, "");
				ОписаниеОшибки	=	ОписаниеОшибки	+	"Не сопоставлен объект: " + Выборка.Объект;
			КонецЕсли;
			Если Выборка.НесопоставленоСтатьяДДС Тогда
				ОписаниеОшибки	=	ОписаниеОшибки	+	?(ЗначениеЗаполнено(ОписаниеОшибки), Символы.ПС, "");
				ОписаниеОшибки	=	ОписаниеОшибки	+	"Не сопоставлена статья ДДС: " + Выборка.СтатьяДДС;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
				ок_ЛогированиеОпераций.ЗаписатьИнформациюОбОшибке(ОписаниеОшибки, Параметры);
			КонецЕсли;
			
		КонецЕсли;
		#КонецОбласти
		
		Результат	=	Истина;
		
		Если Выборка.ТипДокумента = 0 Тогда
			Результат	=	Результат И ЗагрузитьПриходныйКассовыйОрдер(Выборка, Параметры);
		КонецЕсли;
		
		Если Выборка.ТипДокумента = 1 Тогда
			Результат	=	Результат И ЗагрузитьРасходныйКассовыйОрдер(Выборка, Параметры);
		КонецЕсли;
		
		Если Результат Тогда
			УстановитьПризнакЗагрузки(Выборка, 1);
		КонецЕсли;
		
		ЗавершеноУспешно	=	ЗавершеноУспешно И Результат;
		
	КонецЦикла;
	
	#Область Логирование
	
	Если ИспользоватьЛогирование Тогда
		ПараметрыЛогирования.Вставить("ДатаОкончания",	ТекущаяДатаСеанса());
		ПараметрыЛогирования.Вставить("Состояние",		?(ЗавершеноУспешно, 1, 2));
		
		ок_ЛогированиеОпераций.ЗаписастьЛогДО(ПараметрыЛогирования);
	КонецЕсли;
	
	#КонецОбласти
	
	Возврат ЗавершеноУспешно;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗагрузитьПриходныйКассовыйОрдер(Выборка, Параметры)
	
	Попытка
		Если ЗначениеЗаполнено(Выборка.ПриходныйКассовыйОрдерСсылка) Тогда
			ДокументОбъект	=	Выборка.ПриходныйКассовыйОрдерСсылка.ПолучитьОбъект();
			Если ДокументОбъект = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
			Если ДокументОбъект.ПометкаУдаления Тогда
				ДокументОбъект.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
		Иначе
			ДокументОбъект			=	Документы.ПриходныйКассовыйОрдер.СоздатьДокумент();
			ДокументОбъект.Дата		=	НачалоДня(Выборка.Дата);
			ДокументОбъект.Номер	=	Выборка.Номер;	
		КонецЕсли;
		
		Если Не ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход Тогда
			ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийПКО.ПрочийПриход;
		КонецЕсли;
		
		Если Не ДокументОбъект.СчетКасса = ПланыСчетов.Хозрасчетный.КассаОрганизации Тогда
			ДокументОбъект.СчетКасса = ПланыСчетов.Хозрасчетный.КассаОрганизации;
		КонецЕсли;
		
		Если Не ДокументОбъект.Организация = Выборка.ОрганизацияСсылка Тогда
			ДокументОбъект.Организация = Выборка.ОрганизацияСсылка;
		КонецЕсли;
		
		Если Не ДокументОбъект.ок_Объект = Выборка.ОбъектСсылка Тогда
			ДокументОбъект.ок_Объект = Выборка.ОбъектСсылка;
		КонецЕсли;
		
		Если Не ДокументОбъект.ПринятоОт = Выборка.Выдать Тогда
			ДокументОбъект.ПринятоОт = Выборка.Выдать;
		КонецЕсли;
		
		Если Не ДокументОбъект.Основание = Выборка.Основание Тогда
			ДокументОбъект.Основание = Выборка.Основание;
		КонецЕсли;
		
		Если Не ДокументОбъект.СчетУчетаРасчетовСКонтрагентом = Выборка.КорСчетСсылка Тогда
			ДокументОбъект.СчетУчетаРасчетовСКонтрагентом = Выборка.КорСчетСсылка;
		КонецЕсли;
		
		ДанныеСчета	=	БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Выборка.КорСчетСсылка);
		
		Для Индекс = 1 По 3 Цикл
			
			ТипЗначения	=	ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			
			Если ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Контрагенты") Тогда
				ЗначениеСубконто	=	Выборка.КонтрагентСсылка;
			ИначеЕсли ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов") Тогда
				ЗначениеСубконто	=	Выборка.ДоговорСсылка;
			ИначеЕсли ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ОбъектыСтроительства") Тогда
				ЗначениеСубконто	=	Выборка.ОбъектСсылка;
			ИначеЕсли ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтатьиДвиженияДенежныхСредств") Тогда
				ЗначениеСубконто	=	Выборка.СтатьяДДССсылка;
			ИначеЕсли ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.ОК_ВидыПереводов") Тогда
				ЗначениеСубконто	=	Перечисления.ОК_ВидыПереводов.Инкассация;
			Иначе
				ЗначениеСубконто	=	Неопределено;	
			КонецЕсли;
			
			Если Не ДокументОбъект["СубконтоКт" + Индекс] = ЗначениеСубконто Тогда 
				ДокументОбъект["СубконтоКт" + Индекс] = ЗначениеСубконто;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не ДокументОбъект.СтатьяДвиженияДенежныхСредств = Выборка.СтатьяДДССсылка Тогда
			ДокументОбъект.СтатьяДвиженияДенежныхСредств = Выборка.СтатьяДДССсылка;
		КонецЕсли;
		
		ВалютаДокумента	=	Выборка.ДоговорСсылка.ВалютаВзаиморасчетов;
			
		Если Не ДокументОбъект.ВалютаДокумента = ВалютаДокумента Тогда
			ДокументОбъект.ВалютаДокумента	=	ВалютаДокумента;
		КонецЕсли;
		
		Если Не ДокументОбъект.СуммаДокумента = Выборка.Сумма Тогда
			ДокументОбъект.СуммаДокумента = Выборка.Сумма;
		КонецЕсли;
		
		Если ДокументОбъект.Модифицированность() Тогда
			
			ДокументОбъект.Ответственный	=	Пользователи.ТекущийПользователь();
			ДокументОбъект.Комментарий		=	Выборка.Комментарий + " " + Формат(ТекущаяДатаСеанса(), "ДЛФ=DT");
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
			#Область Логирование
			ок_ЛогированиеОпераций.ЗаписатьСообщенияПользователю("Проведен документ: " + ДокументОбъект.Ссылка, Параметры);
			#КонецОбласти
			
		Иначе
			
			#Область Логирование
			ок_ЛогированиеОпераций.ЗаписатьСообщенияПользователю("Документ не был изменен: " + ДокументОбъект.Ссылка, Параметры);
			#КонецОбласти
			
		КонецЕсли;
		
	Исключение
		ОписаниеОшибки	=	ОписаниеОшибки();
		
		#Область Логирование
		ок_ЛогированиеОпераций.ЗаписатьИнформациюОбОшибке(ОписаниеОшибки, Параметры);
		#КонецОбласти
		
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ЗагрузитьРасходныйКассовыйОрдер(Выборка, Параметры)
	
	Попытка
		Если ЗначениеЗаполнено(Выборка.РасходныйКассовыйОрдерСсылка) Тогда
			ДокументОбъект	=	Выборка.РасходныйКассовыйОрдерСсылка.ПолучитьОбъект();
			Если ДокументОбъект = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
			Если ДокументОбъект.ПометкаУдаления Тогда
				ДокументОбъект.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
		Иначе
			ДокументОбъект			=	Документы.РасходныйКассовыйОрдер.СоздатьДокумент();
			ДокументОбъект.Дата		=	НачалоДня(Выборка.Дата);
			ДокументОбъект.Номер	=	Выборка.Номер;	
		КонецЕсли;
		
		Если Не ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийРКО.ПрочийРасход Тогда
			ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийРКО.ПрочийРасход;
		КонецЕсли;
		
		Если Не ДокументОбъект.СчетКасса = ПланыСчетов.Хозрасчетный.КассаОрганизации Тогда
			ДокументОбъект.СчетКасса = ПланыСчетов.Хозрасчетный.КассаОрганизации;
		КонецЕсли;
		
		Если Не ДокументОбъект.Организация = Выборка.ОрганизацияСсылка Тогда
			ДокументОбъект.Организация = Выборка.ОрганизацияСсылка;
		КонецЕсли;
		
		Если Не ДокументОбъект.ВидНалоговогоОбязательства = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
			ДокументОбъект.ВидНалоговогоОбязательства = Перечисления.ВидыПлатежейВГосБюджет.Налог;
		КонецЕсли;
		
		Если Не ДокументОбъект.ок_Объект = Выборка.ОбъектСсылка Тогда
			ДокументОбъект.ок_Объект = Выборка.ОбъектСсылка;
		КонецЕсли;
		
		Если Не ДокументОбъект.Выдать = Выборка.Выдать Тогда
			ДокументОбъект.Выдать = Выборка.Выдать;
		КонецЕсли;
		
		Если Не ДокументОбъект.Основание = Выборка.Основание Тогда
			ДокументОбъект.Основание = Выборка.Основание;
		КонецЕсли;
		
		Если Не ДокументОбъект.СчетУчетаРасчетовСКонтрагентом = Выборка.КорСчетСсылка Тогда
			ДокументОбъект.СчетУчетаРасчетовСКонтрагентом = Выборка.КорСчетСсылка;
		КонецЕсли;
		
		ДанныеСчета	=	БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Выборка.КорСчетСсылка);
		
		Для Индекс = 1 По 3 Цикл
			
			ТипЗначения	=	ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			
			Если ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Контрагенты") Тогда
				ЗначениеСубконто	=	Выборка.КонтрагентСсылка;
			ИначеЕсли ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов") Тогда
				ЗначениеСубконто	=	Выборка.ДоговорСсылка;
			ИначеЕсли ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ОбъектыСтроительства") Тогда
				ЗначениеСубконто	=	Выборка.ОбъектСсылка;
			ИначеЕсли ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтатьиДвиженияДенежныхСредств") Тогда
				ЗначениеСубконто	=	Выборка.СтатьяДДССсылка;
			ИначеЕсли ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.ОК_ВидыПереводов") Тогда
				ЗначениеСубконто	=	Перечисления.ОК_ВидыПереводов.Инкассация;
			Иначе
				ЗначениеСубконто	=	Неопределено;	
			КонецЕсли;
			
			Если Не ДокументОбъект["СубконтоДт" + Индекс] = ЗначениеСубконто Тогда 
				ДокументОбъект["СубконтоДт" + Индекс] = ЗначениеСубконто;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не ДокументОбъект.СтатьяДвиженияДенежныхСредств = Выборка.СтатьяДДССсылка Тогда
			ДокументОбъект.СтатьяДвиженияДенежныхСредств = Выборка.СтатьяДДССсылка;
		КонецЕсли;
		
		ВалютаДокумента	=	Выборка.ДоговорСсылка.ВалютаВзаиморасчетов;
			
		Если Не ДокументОбъект.ВалютаДокумента = ВалютаДокумента Тогда
			ДокументОбъект.ВалютаДокумента	=	ВалютаДокумента;
		КонецЕсли;
		
		Если Не ДокументОбъект.СуммаДокумента = Выборка.Сумма Тогда
			ДокументОбъект.СуммаДокумента = Выборка.Сумма;
		КонецЕсли;
		
		Если ДокументОбъект.Модифицированность() Тогда
			
			ДокументОбъект.Ответственный	=	Пользователи.ТекущийПользователь();
			ДокументОбъект.Комментарий		=	Выборка.Комментарий + " " + Формат(ТекущаяДатаСеанса(), "ДЛФ=DT");
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
			#Область Логирование
			ок_ЛогированиеОпераций.ЗаписатьСообщенияПользователю("Проведен документ: " + ДокументОбъект.Ссылка, Параметры);
			#КонецОбласти
			
		Иначе
			
			#Область Логирование
			ок_ЛогированиеОпераций.ЗаписатьСообщенияПользователю("Документ не был изменен: " + ДокументОбъект.Ссылка, Параметры);
			#КонецОбласти
			
		КонецЕсли;
		
	Исключение
		ОписаниеОшибки	=	ОписаниеОшибки();
		
		#Область Логирование
		ок_ЛогированиеОпераций.ЗаписатьИнформациюОбОшибке(ОписаниеОшибки, Параметры);
		#КонецОбласти
		
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьПараметры(ИспользоватьЛогирование, ЗаписыватьСообщенияПользователю, ПараметрыЛогирования)
	
	Параметры				=	Новый Структура;
	
	Параметры.Вставить("ИспользоватьЛогирование", 			ИспользоватьЛогирование);
	Параметры.Вставить("ЗаписыватьСообщенияПользователю",	ЗаписыватьСообщенияПользователю);
	Параметры.Вставить("ПараметрыЛогирования",				ПараметрыЛогирования);
	
	ИмяНастройкиОрганизация	=	ок_ОбщегоНазначенияФинансы21.ПолучитьИмяНастройкиОрганизацияОКЕЙ();
	Организация				=	ок_ОбщегоНазначенияФинансы21.ПолучитьОрганизацию(ИмяНастройкиОрганизация);
	
	Параметры.Вставить("Организация",	Организация);
	
	#Область Логирование
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ок_ЛогированиеОпераций.ЗаписатьИнформациюОбОшибке("Организация не найдена: " + ИмяНастройкиОрганизация, Параметры);
	КонецЕсли;
	#КонецОбласти
	
	Возврат Параметры;
	
КонецФункции

Процедура УстановитьПризнакЗагрузки(Выборка, ПризнакЗагрузки)
	
	МенеджерЗаписи	=	ВнешниеИсточникиДанных.ок_DAX12_КассовыеОперации_ЗагрузкаДанных.Таблицы.dbo_DAX12_CO_ExportDataTo1C.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка, "НомерЗаписи");
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		Если Не МенеджерЗаписи.Загружен	=	ПризнакЗагрузки Тогда 
			МенеджерЗаписи.Загружен	=	ПризнакЗагрузки;	
			МенеджерЗаписи.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьОтборПоКорСчетам(КорСчета)
	
	Запрос			=	Новый Запрос;
	Запрос.УстановитьПараметр("КорСчета", 				КорСчета);
	Запрос.УстановитьПараметр("ВидАналитикиСчетРСБУ",	Перечисления.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.СчетРСБУ);
	Запрос.Текст	=
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.Аналитика КАК Аналитика
	|ИЗ
	|	РегистрСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA КАК СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA
	|ГДЕ
	|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ВидАналитики = &ВидАналитикиСчетРСБУ
	|	И СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ЗначениеАналитики В(&КорСчета)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Аналитика");
	
КонецФункции

Функция ПолучитьОтборПоОбъекту(ОбъектСсылка)
	
	ИмяНастройкиОрганизация	=	ок_ОбщегоНазначенияФинансы21.ПолучитьИмяНастройкиОрганизацияОКЕЙ();
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("Организация",	ок_ОбщегоНазначенияФинансы21.ПолучитьОрганизацию(ИмяНастройкиОрганизация));
	Запрос.УстановитьПараметр("Объект",			ОбъектСсылка);
	Запрос.Текст	=
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	бит_ок_СопоставлениеАналитикиАксапты12.КодАналитикиАксапты КАК КодАналитикиАксапты
	|ИЗ
	|	РегистрСведений.бит_ок_СопоставлениеАналитикиАксапты12 КАК бит_ок_СопоставлениеАналитикиАксапты12
	|ГДЕ
	|	бит_ок_СопоставлениеАналитикиАксапты12.Организация = &Организация
	|	И бит_ок_СопоставлениеАналитикиАксапты12.Аналитика1С = &Объект
	|	И бит_ок_СопоставлениеАналитикиАксапты12.Тип1С.ВидОбъекта = ЗНАЧЕНИЕ(Перечисление.бит_ВидыОбъектовСистемы.Справочник)
	|	И бит_ок_СопоставлениеАналитикиАксапты12.Тип1С.ИмяОбъекта = ""ОбъектыСтроительства""
	|	И НЕ бит_ок_СопоставлениеАналитикиАксапты12.Тип1С.ПометкаУдаления";
	
	Результат	=	Запрос.Выполнить();
	
	ОбъектСтрока	=	Неопределено;
	
	Если Результат.Пустой() Тогда
		Возврат ОбъектСтрока;	
	Иначе
		Выборка	=	Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			ОбъектСтрока	=	Выборка.КодАналитикиАксапты;	
		КонецЕсли;
	КонецЕсли;	
	
	Возврат ОбъектСтрока;
	
КонецФункции

Функция ПолучитьИнтеграционнуюТаблицу(Параметры)
	
	ДатаНачала			=	Неопределено;
	ДатаОкончания		=	Неопределено;
	Объект				=	Неопределено;
	ПризнакЗагрузки		=	Неопределено;
	КорСчета			=	Неопределено;
	ИгнорироватьПериод	=	Неопределено;
	
	Параметры.Свойство("ДатаНачала",			ДатаНачала);
	Параметры.Свойство("ДатаОкончания",			ДатаОкончания);
	Параметры.Свойство("Объект",				Объект);
	Параметры.Свойство("ПризнакЗагрузки",		ПризнакЗагрузки);
	Параметры.Свойство("КорСчета",				КорСчета);
	Параметры.Свойство("ИгнорироватьПериод",	ИгнорироватьПериод);
	
	ИспользоватьОтборПоКорСчетам		=	ЗначениеЗаполнено(КорСчета);
	ИспользоватьОтборПоПризнакуЗагрузки	=	ПризнакЗагрузки = 0 Или ПризнакЗагрузки = 1;
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала", 							ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", 							ДатаОкончания);
	Запрос.УстановитьПараметр("ИгнорироватьПериод", 					ИгнорироватьПериод);
	Запрос.УстановитьПараметр("ОбъектСтрока", 							ПолучитьОтборПоОбъекту(Объект));
	Запрос.УстановитьПараметр("ИспользоватьОтборПоОбъекту",				ЗначениеЗаполнено(Объект));
	Запрос.УстановитьПараметр("КорСчета", 								ПолучитьОтборПоКорСчетам(КорСчета));
	Запрос.УстановитьПараметр("ИспользоватьОтборПоКорСчетам",			ИспользоватьОтборПоКорСчетам);
	Запрос.УстановитьПараметр("ПризнакЗагрузки", 						ПризнакЗагрузки);
	Запрос.УстановитьПараметр("ИспользоватьОтборПоПризнакуЗагрузки",	ИспользоватьОтборПоПризнакуЗагрузки);
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	dbo_DAX12_CO_ExportDataTo1C.Дата КАК Дата,
	|	dbo_DAX12_CO_ExportDataTo1C.Объект КАК Объект,
	|	dbo_DAX12_CO_ExportDataTo1C.НомерЗаписи КАК НомерЗаписи,
	|	dbo_DAX12_CO_ExportDataTo1C.КодКонтрагента КАК КодКонтрагента,
	|	dbo_DAX12_CO_ExportDataTo1C.КодДоговора КАК КодДоговора,
	|	dbo_DAX12_CO_ExportDataTo1C.Номер КАК Номер,
	|	dbo_DAX12_CO_ExportDataTo1C.СтатьяДДС КАК СтатьяДДС,
	|	dbo_DAX12_CO_ExportDataTo1C.КорСчет КАК КорСчет,
	|	dbo_DAX12_CO_ExportDataTo1C.ТипДокумента КАК ТипДокумента,
	|	dbo_DAX12_CO_ExportDataTo1C.Основание КАК Основание,
	|	dbo_DAX12_CO_ExportDataTo1C.Выдать КАК Выдать,
	|	ЕСТЬNULL(dbo_DAX12_CO_ExportDataTo1C.Сумма, 0) КАК Сумма,
	|	ВЫБОР
	|		КОГДА dbo_DAX12_CO_ExportDataTo1C.Загружен = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Загружен,
	|	dbo_DAX12_CO_ExportDataTo1C.ДатаСоздания КАК ДатаСоздания,
	|	dbo_DAX12_CO_ExportDataTo1C.ДатаИзменения КАК ДатаИзменения
	|ИЗ
	|	ВнешнийИсточникДанных.ок_DAX12_КассовыеОперации_ЗагрузкаДанных.Таблица.dbo_DAX12_CO_ExportDataTo1C КАК dbo_DAX12_CO_ExportDataTo1C
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ИспользоватьОтборПоКорСчетам
	|				ТОГДА dbo_DAX12_CO_ExportDataTo1C.КорСчет В (&КорСчета)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ИспользоватьОтборПоПризнакуЗагрузки
	|				ТОГДА dbo_DAX12_CO_ExportDataTo1C.Загружен = &ПризнакЗагрузки
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ИгнорироватьПериод
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ dbo_DAX12_CO_ExportDataTo1C.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ИспользоватьОтборПоОбъекту
	|				ТОГДА dbo_DAX12_CO_ExportDataTo1C.Объект = &ОбъектСтрока
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	ТипДокумента,
	|	Объект";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьИсточник()
	Возврат "DAX12";	
КонецФункции

Функция Мэппинг(ИнтеграционнаяТаблица, Параметры)
	
	Организация							=	Параметры.Организация;
	
	НесопоставленоСтатьяДДС				=	Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();
	НесопоставленоДоговор				=	Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	НесопоставленоКонтрагент			=	Справочники.Контрагенты.ПустаяСсылка();
	НесопоставленоОбъект				=	Справочники.ОбъектыСтроительства.ПустаяСсылка();
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("Группа",	"Служебные элементы Не сопоставлено");
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.ИмяНастройки КАК ИмяНастройки,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.бит_ок_НастройкиМеханизмаИмпортаДанных КАК бит_ок_НастройкиМеханизмаИмпортаДанных
	|ГДЕ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа = &Группа";
	Результат	=	Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка	=	Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ИмяНастройки = "Договоры" Тогда
				НесопоставленоДоговор		=	Выборка.Значение;
			КонецЕсли;
			Если Выборка.ИмяНастройки = "Контрагенты" Тогда
				НесопоставленоКонтрагент	=	Выборка.Значение;
			КонецЕсли;
			Если Выборка.ИмяНастройки = "Объекты строительства" Тогда
				НесопоставленоОбъект		=	Выборка.Значение;
			КонецЕсли;
			Если Выборка.ИмяНастройки = "Статьи движения денежных средств" Тогда
				НесопоставленоСтатьяДДС		=	Выборка.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("ВидАналитикиСчетРСБУ",		Перечисления.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.СчетРСБУ);
	Запрос.УстановитьПараметр("ТекущаяДата",				ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ИнтеграционнаяТаблица",		ИнтеграционнаяТаблица);
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("Источник",					ПолучитьИсточник());
	
	Запрос.УстановитьПараметр("НесопоставленоДоговор",		НесопоставленоДоговор);
	Запрос.УстановитьПараметр("НесопоставленоКонтрагент",	НесопоставленоКонтрагент);
	Запрос.УстановитьПараметр("НесопоставленоОбъект",		НесопоставленоОбъект);
	Запрос.УстановитьПараметр("НесопоставленоСтатьяДДС",	НесопоставленоСтатьяДДС);
	
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	ИнтеграционнаяТаблица.Дата КАК Дата,
	|	ИнтеграционнаяТаблица.Объект КАК Объект,
	|	ИнтеграционнаяТаблица.Сумма КАК Сумма,
	|	ИнтеграционнаяТаблица.КодКонтрагента КАК КодКонтрагента,
	|	ИнтеграционнаяТаблица.КодДоговора КАК КодДоговора,
	|	ИнтеграционнаяТаблица.КорСчет КАК КорСчет,
	|	ИнтеграционнаяТаблица.СтатьяДДС КАК СтатьяДДС,
	|	ИнтеграционнаяТаблица.Номер КАК Номер,
	|	ИнтеграционнаяТаблица.НомерЗаписи КАК НомерЗаписи,
	|	ИнтеграционнаяТаблица.Основание КАК Основание,
	|	ИнтеграционнаяТаблица.ТипДокумента КАК ТипДокумента,
	|	ИнтеграционнаяТаблица.Выдать КАК Выдать
	|ПОМЕСТИТЬ ИнтеграционнаяТаблица
	|ИЗ
	|	&ИнтеграционнаяТаблица КАК ИнтеграционнаяТаблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИнтеграционнаяТаблица.Дата КАК Дата,
	|	""АХ"" + ПОДСТРОКА(ИнтеграционнаяТаблица.Номер, 12, 9) КАК Номер,
	|	ИнтеграционнаяТаблица.Объект КАК Объект,
	|	ИнтеграционнаяТаблица.КодКонтрагента КАК КодКонтрагента,
	|	ИнтеграционнаяТаблица.КодДоговора КАК КодДоговора,
	|	ИнтеграционнаяТаблица.СтатьяДДС КАК СтатьяДДС,
	|	ИнтеграционнаяТаблица.Сумма КАК Сумма,
	|	ИнтеграционнаяТаблица.НомерЗаписи КАК НомерЗаписи,
	|	ИнтеграционнаяТаблица.Основание КАК Основание,
	|	ИнтеграционнаяТаблица.ТипДокумента КАК ТипДокумента,
	|	ИнтеграционнаяТаблица.Выдать КАК Выдать,
	|	МАКСИМУМ(ВЫРАЗИТЬ(ЕСТЬNULL(бит_ок_СопоставлениеАналитикиАксапты12_Объект.Аналитика1С, &НесопоставленоОбъект) КАК Справочник.ОбъектыСтроительства)) КАК ОбъектСсылка,
	|	МАКСИМУМ(ВЫРАЗИТЬ(ЕСТЬNULL(бит_ок_СопоставлениеАналитикиАксапты12_СтатьяДДС.Аналитика1С, &НесопоставленоСтатьяДДС) КАК Справочник.СтатьиДвиженияДенежныхСредств)) КАК СтатьяДДССсылка,
	|	МАКСИМУМ(ЕСТЬNULL(ДоговорыКонтрагентов.Ссылка, &НесопоставленоДоговор)) КАК ДоговорСсылка,
	|	МАКСИМУМ(ЕСТЬNULL(Контрагенты.Ссылка, &НесопоставленоКонтрагент)) КАК КонтрагентСсылка,
	|	МАКСИМУМ(ВЫРАЗИТЬ(ЕСТЬNULL(СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ЗначениеАналитики, ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.Вспомогательный)) КАК ПланСчетов.Хозрасчетный)) КАК КорСчетСсылка,
	|	МАКСИМУМ(""#"" + ИнтеграционнаяТаблица.Объект + "" ("" + ВЫРАЗИТЬ(ЕСТЬNULL(бит_ок_СопоставлениеАналитикиАксапты12_Объект.Аналитика1С, &НесопоставленоОбъект) КАК Справочник.ОбъектыСтроительства).Наименование + ""). "" + ИнтеграционнаяТаблица.КорСчет + "". Загружен из DAX12"") КАК Комментарий
	|ПОМЕСТИТЬ РезультирующаяТаблица
	|ИЗ
	|	ИнтеграционнаяТаблица КАК ИнтеграционнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО ИнтеграционнаяТаблица.КодДоговора = ДоговорыКонтрагентов.Код
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО ИнтеграционнаяТаблица.КодКонтрагента = Контрагенты.Код
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_ок_СопоставлениеАналитикиАксапты12 КАК бит_ок_СопоставлениеАналитикиАксапты12_СтатьяДДС
	|		ПО ИнтеграционнаяТаблица.СтатьяДДС = бит_ок_СопоставлениеАналитикиАксапты12_СтатьяДДС.КодАналитикиАксапты
	|			И (бит_ок_СопоставлениеАналитикиАксапты12_СтатьяДДС.Организация = &Организация)
	|			И (бит_ок_СопоставлениеАналитикиАксапты12_СтатьяДДС.Тип1С.ВидОбъекта = ЗНАЧЕНИЕ(Перечисление.бит_ВидыОбъектовСистемы.Справочник))
	|			И (бит_ок_СопоставлениеАналитикиАксапты12_СтатьяДДС.Тип1С.ИмяОбъекта = ""СтатьиДвиженияДенежныхСредств"")
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_ок_СопоставлениеАналитикиАксапты12 КАК бит_ок_СопоставлениеАналитикиАксапты12_Объект
	|		ПО ИнтеграционнаяТаблица.Объект = бит_ок_СопоставлениеАналитикиАксапты12_Объект.КодАналитикиАксапты
	|			И (бит_ок_СопоставлениеАналитикиАксапты12_Объект.Организация = &Организация)
	|			И (бит_ок_СопоставлениеАналитикиАксапты12_Объект.Тип1С.ВидОбъекта = ЗНАЧЕНИЕ(Перечисление.бит_ВидыОбъектовСистемы.Справочник))
	|			И (бит_ок_СопоставлениеАналитикиАксапты12_Объект.Тип1С.ИмяОбъекта = ""ОбъектыСтроительства"")
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA КАК СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA
	|		ПО (СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ВидАналитики = &ВидАналитикиСчетРСБУ)
	|			И ИнтеграционнаяТаблица.КорСчет = СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.Аналитика
	|
	|СГРУППИРОВАТЬ ПО
	|	ИнтеграционнаяТаблица.Дата,
	|	ИнтеграционнаяТаблица.Объект,
	|	ИнтеграционнаяТаблица.Сумма,
	|	ИнтеграционнаяТаблица.НомерЗаписи,
	|	ИнтеграционнаяТаблица.Основание,
	|	ИнтеграционнаяТаблица.ТипДокумента,
	|	ИнтеграционнаяТаблица.Выдать,
	|	""АХ"" + ПОДСТРОКА(ИнтеграционнаяТаблица.Номер, 12, 9),
	|	ИнтеграционнаяТаблица.КодДоговора,
	|	ИнтеграционнаяТаблица.КодКонтрагента,
	|	ИнтеграционнаяТаблица.СтатьяДДС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РезультирующаяТаблица.Дата КАК Дата,
	|	РезультирующаяТаблица.Номер КАК Номер,
	|	РезультирующаяТаблица.Объект КАК Объект,
	|	РезультирующаяТаблица.КодКонтрагента КАК КодКонтрагента,
	|	РезультирующаяТаблица.КодДоговора КАК КодДоговора,
	|	РезультирующаяТаблица.СтатьяДДС КАК СтатьяДДС,
	|	РезультирующаяТаблица.Сумма КАК Сумма,
	|	РезультирующаяТаблица.НомерЗаписи КАК НомерЗаписи,
	|	РезультирующаяТаблица.Основание КАК Основание,
	|	РезультирующаяТаблица.ТипДокумента КАК ТипДокумента,
	|	РезультирующаяТаблица.Выдать КАК Выдать,
	|	&Организация КАК ОрганизацияСсылка,
	|	РезультирующаяТаблица.ОбъектСсылка КАК ОбъектСсылка,
	|	РезультирующаяТаблица.СтатьяДДССсылка КАК СтатьяДДССсылка,
	|	РезультирующаяТаблица.КонтрагентСсылка КАК КонтрагентСсылка,
	|	РезультирующаяТаблица.КорСчетСсылка КАК КорСчетСсылка,
	|	РезультирующаяТаблица.ДоговорСсылка КАК ДоговорСсылка,
	|	ЕСТЬNULL(ПриходныйКассовыйОрдер.Ссылка, ЗНАЧЕНИЕ(Документ.ПриходныйКассовыйОрдер.ПустаяСсылка)) КАК ПриходныйКассовыйОрдерСсылка,
	|	ЕСТЬNULL(РасходныйКассовыйОрдер.Ссылка, ЗНАЧЕНИЕ(Документ.РасходныйКассовыйОрдер.ПустаяСсылка)) КАК РасходныйКассовыйОрдерСсылка,
	|	ВЫБОР
	|		КОГДА РезультирующаяТаблица.ОбъектСсылка = &НесопоставленоОбъект
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НесопоставленоОбъект,
	|	ВЫБОР
	|		КОГДА РезультирующаяТаблица.СтатьяДДССсылка = &НесопоставленоСтатьяДДС
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НесопоставленоСтатьяДДС,
	|	ВЫБОР
	|		КОГДА РезультирующаяТаблица.ДоговорСсылка = &НесопоставленоДоговор
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НесопоставленоДоговор,
	|	ВЫБОР
	|		КОГДА РезультирующаяТаблица.КонтрагентСсылка = &НесопоставленоКонтрагент
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НесопоставленоКонтрагент,
	|	РезультирующаяТаблица.Комментарий КАК Комментарий
	|ИЗ
	|	РезультирующаяТаблица КАК РезультирующаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|		ПО РезультирующаяТаблица.Дата = ПриходныйКассовыйОрдер.Дата
	|			И РезультирующаяТаблица.Номер = ПриходныйКассовыйОрдер.Номер
	|			И (РезультирующаяТаблица.ТипДокумента = 0)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|		ПО РезультирующаяТаблица.Дата = РасходныйКассовыйОрдер.Дата
	|			И РезультирующаяТаблица.Номер = РасходныйКассовыйОрдер.Номер
	|			И (РезультирующаяТаблица.ТипДокумента = 1)";
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти