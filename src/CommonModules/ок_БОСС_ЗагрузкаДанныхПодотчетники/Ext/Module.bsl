﻿#Область ПрограммныйИнтерфейс

// Функция - Найти физ лица в БОСС
//
// Параметры:
//  Параметры	 - Структура - Структура параметров со свойствами:
//  							"Организация", "Фамилия", "Имя", "Отчество"
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица найденных физлиц
//
Функция НайтиФизЛицаВБОСС(Параметры) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Организация	=	Неопределено;
	Фамилия		=	Неопределено;
	Имя			=	Неопределено;
	Отчество	=	Неопределено;
	
	Если Не ТипЗнч(Параметры) = Тип("Структура") Тогда
		ОбщегоНазначения.СообщитьПользователю("Передан неверный параметр!");
		Возврат Неопределено;
	КонецЕсли;
	
	Параметры.Свойство("Организация", 	Организация);
	Параметры.Свойство("Фамилия", 		Фамилия);
	Параметры.Свойство("Имя", 			Имя);
	Параметры.Свойство("Отчество", 		Отчество);
	
	Если Не ТипЗнч(Фамилия) = Тип("Строка") Тогда
		Фамилия		=	"";
	КонецЕсли;
	Если Не ТипЗнч(Имя) = Тип("Строка") Тогда
		Имя			=	"";
	КонецЕсли;
	Если Не ТипЗнч(Отчество) = Тип("Строка") Тогда
		Отчество	=	"";
	КонецЕсли;
	
	Запрос			=	Новый Запрос;
	Запрос.УстановитьПараметр("ОрганизацияСтрока", 		ПолучитьОтборПоОрганизации(Организация));
	
	Запрос.УстановитьПараметр("Фамилия", 				Фамилия+"%");
	Запрос.УстановитьПараметр("Имя", 					Имя+"%");
	Запрос.УстановитьПараметр("Отчество", 				Отчество+"%");
	
	Запрос.УстановитьПараметр("ФамилияИспользовать",	ЗначениеЗаполнено(Фамилия));
	Запрос.УстановитьПараметр("ИмяИспользовать",		ЗначениеЗаполнено(Имя));
	Запрос.УстановитьПараметр("ОтчествоИспользовать",	ЗначениеЗаполнено(Отчество));
	
	ТекстЗапроса	=	ПолучитьТекстЗапроса();
	
	ТекстЗапроса	=	ТекстЗапроса
	+ "
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ФамилияИспользовать
	|				ТОГДА ИнтеграционнаяТаблица.Фамилия ПОДОБНО &Фамилия
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ИмяИспользовать
	|				ТОГДА ИнтеграционнаяТаблица.Имя ПОДОБНО &Имя
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ОтчествоИспользовать
	|				ТОГДА ИнтеграционнаяТаблица.Отчество ПОДОБНО &Отчество
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ИнтеграционнаяТаблица.Организация = &ОрганизацияСтрока";
	
	Запрос.Текст	=	ТекстЗапроса;
	
	Возврат МэппингЛайт(Запрос.Выполнить().Выгрузить());
	
КонецФункции

// Функция - Загрузить физ лица из БОСС
//
// Параметры:
//  КодБОСС			 - 							 - Строка или Массив	 - Коды БОСС для загрузки
//  Организация		 - СправочникСсылка.Организации	 - Организация
//  Принудительно	 - Булево						 - Признак принудительной загрузки
// 
// Возвращаемое значение:
//  Соответствие - Соответствие кодов БОСС ссылкам на справочник "ФизическиеЛица"
//
Функция ЗагрузитьФизЛицаИзБОСС(КодБОСС, Организация, Принудительно = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СоответствиеФизическихЛиц	=	Новый Соответствие;
	
	МассивКодовБОСС	=	Новый Массив;
	Если ТипЗнч(КодБОСС) = Тип("Строка") Тогда
		МассивКодовБОСС.Добавить(КодБОСС);
	ИначеЕсли ТипЗнч(КодБОСС) = Тип("Массив") Тогда
		Для Каждого ЭлементМассива Из КодБОСС Цикл
			//Если ТипЗнч(ЭлементМассива) = Тип("Число") Тогда
			МассивКодовБОСС.Добавить(ЭлементМассива);
			//Иначе
			//	ОбщегоНазначения.СообщитьПользователю("Передан неверный параметр!");
			//	Возврат Неопределено;	
			//КонецЕсли;
		КонецЦикла;
	Иначе
		ОбщегоНазначения.СообщитьПользователю("Передан неверный параметр!");
		Возврат Неопределено;		
	КонецЕсли;
	
	ФорматироватьМассив(МассивКодовБОСС);
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("МассивКодовБОСС", 	МассивКодовБОСС);
	Запрос.УстановитьПараметр("ОрганизацияСтрока",	ПолучитьОтборПоОрганизации(Организация));
	
	ТекстЗапроса	=	ПолучитьТекстЗапроса();
	
	ТекстЗапроса	=	ТекстЗапроса
	+ "
	|ГДЕ
	|	ИнтеграционнаяТаблица.КодБОСС В(&МассивКодовБОСС)
	|	И ИнтеграционнаяТаблица.Организация = &ОрганизацияСтрока";
	
	Запрос.Текст	=	ТекстЗапроса;
	
	НайденныеСтроки	=	МэппингЛайт(Запрос.Выполнить().Выгрузить());
	
	Для Каждого СтрокаТаблицыЗначений Из НайденныеСтроки Цикл
		ФизическоеЛицоСсылка	=	НайтиСоздатьФизическоеЛицо(СтрокаТаблицыЗначений);	
		
		СоответствиеФизическихЛиц.Вставить(СтрокаТаблицыЗначений.КодБОСС, ФизическоеЛицоСсылка);
	КонецЦикла;
	
	Если Ложь Тогда
		НайденныеСтроки	=	Новый ТаблицаЗначений;
	КонецЕсли;
	
	МассивФизическихЛиц	=	Новый Массив;
	Для Каждого КлючИЗначение Из СоответствиеФизическихЛиц Цикл
		МассивФизическихЛиц.Добавить(КлючИЗначение.Значение);
	КонецЦикла;
	
	ЗагрузитьДанныеФизЛицИзБОСС(МассивКодовБОСС, Принудительно);
	
	ОбновитьДанныеФизЛицИзБОСС(МассивФизическихЛиц);
	
	Возврат СоответствиеФизическихЛиц;	
	
КонецФункции

Функция ЗагрузитьДанныеФизЛицИзБОСС(КодБОСС, Принудительно = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивКодовБОСС	=	Новый Массив;
	Если ТипЗнч(КодБОСС) = Тип("Строка") Тогда
		МассивКодовБОСС.Добавить(КодБОСС);
	ИначеЕсли ТипЗнч(КодБОСС) = Тип("Массив") Тогда
		Для Каждого ЭлементМассива Из КодБОСС Цикл
			//	Если ТипЗнч(ЭлементМассива) = Тип("Число") Тогда
			МассивКодовБОСС.Добавить(ЭлементМассива);
			//	Иначе
			//		ОбщегоНазначения.СообщитьПользователю("Передан неверный параметр!");
			//		Возврат Ложь;	
			//	КонецЕсли;
		КонецЦикла;
	Иначе
		ОбщегоНазначения.СообщитьПользователю("Передан неверный параметр!");
		Возврат Ложь;		
	КонецЕсли;
	
	ФорматироватьМассив(МассивКодовБОСС);
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("Принудительно", 		Принудительно);
	Запрос.УстановитьПараметр("МассивКодовБОСС", 	МассивКодовБОСС);
	
	ТекстЗапроса	=	ПолучитьТекстЗапроса();
	
	ТекстЗапроса	=	ТекстЗапроса
	+ "
	|ГДЕ
	|	ИнтеграционнаяТаблица.КодБОСС В(&МассивКодовБОСС)
	|	И ВЫБОР КОГДА &Принудительно ТОГДА ИСТИНА ИНАЧЕ ИнтеграционнаяТаблица.Загружен = 0 КОНЕЦ";
	
	Запрос.Текст	=	ТекстЗапроса;
	
	НайденныеСтроки	=	Запрос.Выполнить().Выгрузить();
	
	ЕстьИзменения	=	Мэппинг(НайденныеСтроки);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		
		МенеджерЗаписи				=	ВнешниеИсточникиДанных.ок_БОСС_ЗагрузкаДанныхПодотчетники.Таблицы.dbo_BOSS_ExportDataTo1C.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.КодБОСС		=	НайденнаяСтрока.КодБОСС;
		МенеджерЗаписи.Организация	=	НайденнаяСтрока.Организация;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() Тогда
			Если Не МенеджерЗаписи.Загружен	=	1 Тогда 
				МенеджерЗаписи.Загружен	=	1;	
				МенеджерЗаписи.Записать();
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;	
	
КонецФункции

Процедура РЗ_ОбновитьДанныеФизЛицИзБОСС() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос	=	Новый Запрос;
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо,
	|	ФизическиеЛица.ок_КодФизическогоЛицаБОСС КАК КодБосс
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	НЕ ФизическиеЛица.ЭтоГруппа
	|	И НЕ ФизическиеЛица.ок_КодФизическогоЛицаБОСС = """"";
	
	ТаблицаФизическихЛиц	=	Запрос.Выполнить().Выгрузить();
	
	ЗагрузитьДанныеФизЛицИзБОСС(ТаблицаФизическихЛиц.ВыгрузитьКолонку("КодБосс"), Ложь);
	ОбновитьДанныеФизЛицИзБОСС(ТаблицаФизическихЛиц.ВыгрузитьКолонку("ФизическоеЛицо"));
	
КонецПроцедуры

Функция ОбновитьДанныеФизЛицИзБОСС(МассивФизическихЛиц) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("КодПФР", "ИНПАСПОРТ");
	Запрос.Текст	=
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыДокументовФизическихЛиц.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыДокументовФизическихЛиц КАК ВидыДокументовФизическихЛиц
	|ГДЕ
	|	НЕ ВидыДокументовФизическихЛиц.ПометкаУдаления
	|	И ВидыДокументовФизическихЛиц.КодПФР = &КодПФР";
	Результат	=	Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		ИностранныйПаспорт =	Справочники.ВидыДокументовФизическихЛиц.ЗагранпаспортРФ;
	Иначе
		Выборка	=	Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			ИностранныйПаспорт	=	Выборка.Ссылка;	
		КонецЕсли;
	КонецЕсли;
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("МассивФизическихЛиц", МассивФизическихЛиц);
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Период КАК Период,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.ТабельныйНомер КАК ТабельныйНомер,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Организация КАК Организация,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.КодБОСС КАК КодБОСС,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Фамилия КАК Фамилия,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Имя КАК Имя,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Отчество КАК Отчество,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.ДатаРождения КАК ДатаРождения,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Гражданство КАК Гражданство,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.СерияДокумента КАК СерияДокумента,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.НомерДокумента КАК НомерДокумента,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Период КАК ДатаПеревода,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.КемВыданДокумент КАК КемВыданДокумент,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Должность КАК Должность,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Функция КАК Функция,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.Объект КАК Объект,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.ДатаПриема КАК ДатаПриема,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.ДатаУвольнения КАК ДатаУвольнения,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.КодПриемаНаРаботу КАК КодПриемаНаРаботу,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.БИКБанка КАК БИКБанка,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.НомерРасчетногоСчета КАК НомерРасчетногоСчета,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.ФункцияКод КАК ФункцияКод,
	|	ок_ДанныеФизическихЛицБОСССрезПоследних.ОбъектКод КАК ОбъектКод
	|ИЗ
	|	РегистрСведений.ок_ДанныеФизическихЛицБОСС.СрезПоследних(, ФизическоеЛицо В (&МассивФизическихЛиц)) КАК ок_ДанныеФизическихЛицБОСССрезПоследних";
	
	Результат	=	Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка	=	Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ФизическоеЛицо			=	Выборка.ФизическоеЛицо;
			ОсновнойБанковскийСчет	=	НайтиСоздатьБанковскийСчет(ФизическоеЛицо, Выборка);
			
			Если Не ФизическоеЛицо.ОсновнойБанковскийСчет	=	ОсновнойБанковскийСчет Тогда
				ФизическоеЛицоОбъект	=	ФизическоеЛицо.ПолучитьОбъект();
				Если Не ФизическоеЛицоОбъект = Неопределено Тогда
					ФизическоеЛицоОбъект.ОсновнойБанковскийСчет	=	ОсновнойБанковскийСчет;
					ФизическоеЛицоОбъект.Записать();
				КонецЕсли;
			КонецЕсли;	
			
			ЗаписатьФИОФизическихЛиц(ФизическоеЛицо, Выборка);
			ЗаписатьДокументыФизическихЛиц(ФизическоеЛицо, Выборка, ИностранныйПаспорт);
			
		КонецЦикла;
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиСоздатьФизическоеЛицо(ДанныеСтроки)
	
	Если ЗначениеЗаполнено(ДанныеСтроки.ФизическоеЛицо) Тогда
		СправочникОбъект	=	ДанныеСтроки.ФизическоеЛицо.ПолучитьОбъект();
	Иначе	
		СправочникОбъект	=	Справочники.ФизическиеЛица.СоздатьЭлемент();
		СправочникОбъект.ок_КодФизическогоЛицаБОСС	=	ДанныеСтроки.КодБОСС;
	КонецЕсли;
	
	Если Не СправочникОбъект.Фамилия = ДанныеСтроки.Фамилия Тогда
		СправочникОбъект.Фамилия = ДанныеСтроки.Фамилия;
	КонецЕсли;
	Если Не СправочникОбъект.Имя = ДанныеСтроки.Имя Тогда
		СправочникОбъект.Имя = ДанныеСтроки.Имя;
	КонецЕсли;
	Если Не СправочникОбъект.Отчество = ДанныеСтроки.Отчество Тогда
		СправочникОбъект.Отчество = ДанныеСтроки.Отчество;
	КонецЕсли;
	
	Если Не СправочникОбъект.ДатаРождения = ДанныеСтроки.ДатаРождения Тогда
		СправочникОбъект.ДатаРождения = ДанныеСтроки.ДатаРождения;
	КонецЕсли;
	
	Если Не СправочникОбъект.Пол = ДанныеСтроки.Пол Тогда
		СправочникОбъект.Пол = ДанныеСтроки.Пол;
	КонецЕсли;
	
	Наименование	=	КадровыйУчетКлиентСервер.ПолноеНаименованиеСотрудника(
							ДанныеСтроки.Фамилия, ДанныеСтроки.Имя, ДанныеСтроки.Отчество, СправочникОбъект.УточнениеНаименования);
							
	Если Не СправочникОбъект.Наименование = Наименование Тогда
		СправочникОбъект.Наименование = Наименование;
	КонецЕсли;
	
	Если Не СправочникОбъект.ФИО = Наименование Тогда
		СправочникОбъект.ФИО = Наименование;
	КонецЕсли;
	
	Если СправочникОбъект.Модифицированность() Тогда
		СправочникОбъект.Записать();
		ЗаписатьФИОФизическихЛиц(СправочникОбъект.Ссылка, ДанныеСтроки);
	КонецЕсли;
	
	//ОсновнойБанковскийСчет	=	НайтиСоздатьБанковскийСчет(СправочникОбъект.Ссылка, ДанныеСтроки);
	//
	//Если Не СправочникОбъект.ОсновнойБанковскийСчет	=	ОсновнойБанковскийСчет Тогда 
	//	СправочникОбъект.ОсновнойБанковскийСчет	=	ОсновнойБанковскийСчет;
	//	СправочникОбъект.Записать();
	//КонецЕсли;
	
	Возврат СправочникОбъект.Ссылка;	
	
КонецФункции

Процедура ЗаписатьДокументыФизическихЛиц(ФизическоеЛицо, ДанныеСтроки, ИностранныйПаспорт)
	
	Если СокрЛП(ДанныеСтроки.Гражданство) = "РОССИЯ" Тогда
		ВидДокумента	=	Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ;
	Иначе
		ВидДокумента	=	ИностранныйПаспорт;
	КонецЕсли;
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("Физлицо", 			ФизическоеЛицо);
	Запрос.УстановитьПараметр("ВидДокумента",		ВидДокумента);
	Запрос.УстановитьПараметр("Период", 			ДанныеСтроки.ДатаПеревода);
	Запрос.УстановитьПараметр("Серия",				ДанныеСтроки.СерияДокумента);
	Запрос.УстановитьПараметр("Номер",				ДанныеСтроки.НомерДокумента);
	Запрос.УстановитьПараметр("КемВыдан",			ДанныеСтроки.КемВыданДокумент);
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	ДокументыФизическихЛицСрезПоследних.Физлицо КАК Физлицо
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
	|			&Период,
	|			Физлицо = &Физлицо
	|				И ВидДокумента = &ВидДокумента) КАК ДокументыФизическихЛицСрезПоследних
	|ГДЕ
	|	ДокументыФизическихЛицСрезПоследних.Серия = &Серия
	|	И ДокументыФизическихЛицСрезПоследних.Номер = &Номер
	|	И ДокументыФизическихЛицСрезПоследних.КемВыдан = &КемВыдан";
	
	Результат	=	Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		НаборЗаписей			=	РегистрыСведений.ДокументыФизическихЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Физлицо.Установить(ФизическоеЛицо);
		НаборЗаписей.Прочитать();
		
		Запись					=	НаборЗаписей.Добавить();
		Запись.ВидДокумента		=	ВидДокумента;
		Запись.Физлицо			=	ФизическоеЛицо;
		Запись.Период			=	ДанныеСтроки.ДатаПеревода;
		Запись.Серия			=	ДанныеСтроки.СерияДокумента;
		Запись.Номер			=	ДанныеСтроки.НомерДокумента;
		Запись.ДатаВыдачи		=	ДанныеСтроки.ДатаПеревода;
		Запись.КемВыдан			=	ДанныеСтроки.КемВыданДокумент;
		Запись.СтранаВыдачи		=	Справочники.СтраныМира.Россия;
		Запись.Представление 	=	РегистрыСведений.ДокументыФизическихЛиц.ПредставлениеЗаписи(Запись);
		
		Запись.ЯвляетсяДокументомУдостоверяющимЛичность	=	Истина;
		
		// Обязательно нужно отключить бизнес-логику при записи!
		НаборЗаписей.ОбменДанными.Загрузка	=	Истина;
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьФИОФизическихЛиц(ФизическоеЛицо, ДанныеСтроки)
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.УстановитьПараметр("Период", 		ДанныеСтроки.ДатаПеревода);
	Запрос.УстановитьПараметр("Фамилия", 		ДанныеСтроки.Фамилия);
	Запрос.УстановитьПараметр("Имя", 			ДанныеСтроки.Имя);
	Запрос.УстановитьПараметр("Отчество", 		ДанныеСтроки.Отчество);
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	ФИОФизическихЛицСрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ФИОФизическихЛиц.СрезПоследних(&Период, ФизическоеЛицо = &ФизическоеЛицо) КАК ФИОФизическихЛицСрезПоследних
	|ГДЕ
	|	ФИОФизическихЛицСрезПоследних.Фамилия = &Фамилия
	|	И ФИОФизическихЛицСрезПоследних.Имя = &Имя
	|	И ФИОФизическихЛицСрезПоследних.Отчество = &Отчество";
	
	Результат	=	Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		НаборЗаписей	=	РегистрыСведений.ФИОФизическихЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ФизическоеЛицо.Установить(ФизическоеЛицо);
		НаборЗаписей.Отбор.Период.Установить(ДанныеСтроки.ДатаПеревода);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		
		Запись					=	НаборЗаписей.Добавить();
		Запись.ФизическоеЛицо	=	ФизическоеЛицо;
		Запись.Период			=	ДанныеСтроки.ДатаПеревода;
		Запись.Фамилия			=	ДанныеСтроки.Фамилия;
		Запись.Имя				=	ДанныеСтроки.Имя;
		Запись.Отчество			=	ДанныеСтроки.Отчество;
		
		// Обязательно нужно отключить бизнес-логику при записи!
		НаборЗаписей.ОбменДанными.Загрузка	=	Истина;
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиСоздатьБанковскийСчет(ФизическоеЛицо, ДанныеСтроки)
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("ФизическоеЛицо",	ФизическоеЛицо);
	Запрос.УстановитьПараметр("НомерСчета",		ДанныеСтроки.НомерРасчетногоСчета);
	Запрос.Текст	=
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	БанковскиеСчета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Владелец = &ФизическоеЛицо
	|	И НЕ БанковскиеСчета.ПометкаУдаления
	|	И БанковскиеСчета.НомерСчета = &НомерСчета";
	Результат	=	Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		СправочникОбъект				=	Справочники.БанковскиеСчета.СоздатьЭлемент();	
		СправочникОбъект.Владелец		=	ФизическоеЛицо;
		СправочникОбъект.НомерСчета		=	ДанныеСтроки.НомерРасчетногоСчета;
		СправочникОбъект.Наименование	=	ДанныеСтроки.НомерРасчетногоСчета;
	Иначе
		Выборка	=	Результат.Выбрать();	
		Если Выборка.Следующий() Тогда
			СправочникОбъект	=	Выборка.Ссылка.ПолучитьОбъект();
		КонецЕсли;
	КонецЕсли;
	
	Если СправочникОбъект = Неопределено Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	Банк	=	Справочники.Банки.НайтиПоКоду(ДанныеСтроки.БИКБанка);
	
	Если Не СправочникОбъект.Банк = Банк Тогда
		СправочникОбъект.Банк = Банк;	
	КонецЕсли;
	
	ЯвляетсяБанкомРФ 		=	(Банк.Страна = Справочники.СтраныМира.Россия);
	
	ТекстОшибки				=	"";
	НомерСчетаКорректен 	=	БанковскиеСчетаФормыКлиентСервер.НомерСчетаКорректен(ДанныеСтроки.НомерРасчетногоСчета, ДанныеСтроки.БИКБанка, ЯвляетсяБанкомРФ, ТекстОшибки);
	
	ВалютаДенежныхСредств 	= 	ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	Валютный 				= 	Ложь;
	
	Если НомерСчетаКорректен И ЯвляетсяБанкомРФ Тогда
		Если Не БанковскиеПравила.ЭтоРублевыйСчет(ДанныеСтроки.НомерРасчетногоСчета) Тогда
			КодВалюты 				=	БанковскиеПравила.КодВалютыБанковскогоСчета(ДанныеСтроки.НомерРасчетногоСчета);
			ВалютаДенежныхСредств 	=	БанковскиеСчетаВызовСервера.ПолучитьВалютуПоКоду(КодВалюты);
			Валютный 				=	Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Не СправочникОбъект.Валютный = Валютный Тогда
		СправочникОбъект.Валютный = Валютный;
		
	КонецЕсли;
	
	Если Не СправочникОбъект.ВалютаДенежныхСредств = ВалютаДенежныхСредств Тогда
		СправочникОбъект.ВалютаДенежныхСредств = ВалютаДенежныхСредств;
	КонецЕсли;
	
	Если СправочникОбъект.Валютный Тогда
		СчетБанк = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ВалютныеСчета");
	Иначе
		СчетБанк = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасчетныеСчета");
	КонецЕсли;
	
	Если Не СправочникОбъект.СчетБанк = СчетБанк Тогда
		СправочникОбъект.СчетБанк = СчетБанк;
	КонецЕсли;
	
	Если СправочникОбъект.Модифицированность() Тогда 
		СправочникОбъект.Записать();
	КонецЕсли;
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

Функция ПолучитьТекстЗапроса()
	
	// Получение данных из нескольких источников данных недопустимо.
	ТекстЗапроса	=
	"ВЫБРАТЬ
	|	ИнтеграционнаяТаблица.ДатаПеревода КАК ДатаПеревода,
	|	ИнтеграционнаяТаблица.КодБОСС КАК КодБОСС,
	|	ИнтеграционнаяТаблица.ТабельныйНомер КАК ТабельныйНомер,
	|	ИнтеграционнаяТаблица.Фамилия КАК Фамилия,
	|	ИнтеграционнаяТаблица.Имя КАК Имя,
	|	ИнтеграционнаяТаблица.Отчество КАК Отчество,
	|	ИнтеграционнаяТаблица.Должность КАК Должность,
	|	ИнтеграционнаяТаблица.Объект КАК Объект,
	|	ИнтеграционнаяТаблица.ДатаРождения КАК ДатаРождения,
	|	ИнтеграционнаяТаблица.ДатаПриема КАК ДатаПриема,
	|	ЕСТЬNULL(ИнтеграционнаяТаблица.ДатаУвольнения, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаУвольнения,
	|	ИнтеграционнаяТаблица.ЦФО КАК ЦФО,
	|	ИнтеграционнаяТаблица.БИК КАК БИК,
	|	ИнтеграционнаяТаблица.НомерСчета КАК НомерСчета,
	|	ИнтеграционнаяТаблица.СерияДокумента КАК СерияДокумента,
	|	ИнтеграционнаяТаблица.НомерДокумента КАК НомерДокумента,
	|	ИнтеграционнаяТаблица.ДатаПолучения КАК ДатаПолучения,
	|	ИнтеграционнаяТаблица.КемВыдан КАК КемВыдан,
	|	ИнтеграционнаяТаблица.Гражданство КАК Гражданство,
	|	ИнтеграционнаяТаблица.Организация КАК Организация,
	|	ИнтеграционнаяТаблица.КодПриемаНаРаботу КАК КодПриемаНаРаботу,
	|	ИнтеграционнаяТаблица.Пол КАК Пол,
	|	ИнтеграционнаяТаблица.Загружен КАК Загружен,
	|	ИнтеграционнаяТаблица.ДатаИзменения КАК ДатаИзменения
	|ИЗ
	|	ВнешнийИсточникДанных.ок_БОСС_ЗагрузкаДанныхПодотчетники.Таблица.dbo_BOSS_ExportDataTo1C КАК ИнтеграционнаяТаблица";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПолучитьИсточник()
	Возврат "БОСС";	
КонецФункции

Функция ПолучитьОтборПоОрганизации(ОрганизацияСсылка)
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("Источник", 		ПолучитьИсточник());
	Запрос.УстановитьПараметр("Организация", 	ОрганизацияСсылка);
	Запрос.Текст	=
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ок_СопоставлениеАналитикиДляИнтеграций.АналитикаИсточника КАК АналитикаИсточника
	|ИЗ
	|	РегистрСведений.ок_СопоставлениеАналитикиДляИнтеграций КАК ок_СопоставлениеАналитикиДляИнтеграций
	|ГДЕ
	|	ок_СопоставлениеАналитикиДляИнтеграций.Источник = &Источник
	|	И ок_СопоставлениеАналитикиДляИнтеграций.Организация = &Организация
	|	И ок_СопоставлениеАналитикиДляИнтеграций.Аналитика1С = &Организация
	|	И ок_СопоставлениеАналитикиДляИнтеграций.Тип1С.ВидОбъекта = ЗНАЧЕНИЕ(Перечисление.бит_ВидыОбъектовСистемы.Справочник)
	|	И ок_СопоставлениеАналитикиДляИнтеграций.Тип1С.ИмяОбъекта = ""Организации""
	|	И НЕ ок_СопоставлениеАналитикиДляИнтеграций.Тип1С.ПометкаУдаления";
	
	Результат	=	Запрос.Выполнить();
	
	ОрганизацияСтрока	=	"";
	
	Если Результат.Пустой() Тогда
		ОбщегоНазначения.СообщитьПользователю("Не найдено соответствие для организации: " + ОрганизацияСсылка);
		Возврат Неопределено;	
	Иначе
		Выборка	=	Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			ОрганизацияСтрока	=	Выборка.АналитикаИсточника;	
		КонецЕсли;
	КонецЕсли;	
	
	Возврат ОрганизацияСтрока;
	
КонецФункции

Процедура ФорматироватьМассив(Массив)
	
	//Для Счетчик = 0 По Массив.ВГраница() Цикл
	//	Если ТипЗнч(Массив[Счетчик]) = Тип("Число") Тогда
	//		Массив[Счетчик]	=	Формат(Массив[Счетчик], "ЧГ=");		
	//	КонецЕсли;
	//КонецЦикла;
	
	Для Счетчик = 0 По Массив.ВГраница() Цикл
		Если ТипЗнч(Массив[Счетчик]) = Тип("Строка") Тогда
			Массив[Счетчик]	=	Число(Массив[Счетчик]);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ФорматироватьТаблицуЗначений(ТаблицаЗначений)
	
	Если Не ТаблицаЗначений.Колонки.Найти("КодБОСС") = Неопределено Тогда
		Если ТаблицаЗначений.Колонки.Найти("КодБОСССтрока") = Неопределено Тогда
			МассивТипов			=	Новый Массив;
			МассивТипов.Добавить(Тип("Строка"));
			ОписаниеТиповСтрока	=	Новый ОписаниеТипов(МассивТипов, , , , Новый КвалификаторыСтроки(8));
			
			ТаблицаЗначений.Колонки.Добавить("КодБОСССтрока", ОписаниеТиповСтрока);
		КонецЕсли;
		
		Для Каждого Строка Из ТаблицаЗначений Цикл
			Строка.КодБОСССтрока	=	Формат(Строка.КодБОСС, "ЧГ=");	
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция МэппингЛайт(НайденныеСтроки)
	
	ФорматироватьТаблицуЗначений(НайденныеСтроки);
	
	Запрос	=	Новый Запрос;
	Запрос.УстановитьПараметр("НайденныеСтроки", 	НайденныеСтроки);
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	НайденныеСтроки.КодБОСССтрока КАК КодБОСС,
	|	НайденныеСтроки.ТабельныйНомер КАК ТабельныйНомер,
	|	НайденныеСтроки.Фамилия КАК Фамилия,
	|	НайденныеСтроки.Имя КАК Имя,
	|	НайденныеСтроки.Отчество КАК Отчество,
	|	НайденныеСтроки.Должность КАК Должность,
	|	НайденныеСтроки.Объект КАК Объект,
	|	НайденныеСтроки.ДатаРождения КАК ДатаРождения,
	|	НайденныеСтроки.ДатаПриема КАК ДатаПриема,
	|	НайденныеСтроки.ДатаУвольнения КАК ДатаУвольнения,
	|	НайденныеСтроки.Организация КАК Организация,
	|	НайденныеСтроки.Пол КАК Пол,
	|	НайденныеСтроки.ДатаПеревода КАК ДатаПеревода
	|ПОМЕСТИТЬ НайденныеСтроки
	|ИЗ
	|	&НайденныеСтроки КАК НайденныеСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ФизическиеЛица.Ссылка) КАК ФизическоеЛицо,
	|	НайденныеСтроки.КодБОСС КАК КодБОСС
	|ПОМЕСТИТЬ ФизическиеЛица
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НайденныеСтроки КАК НайденныеСтроки
	|		ПО ФизическиеЛица.ок_КодФизическогоЛицаБОСС = НайденныеСтроки.КодБОСС
	|ГДЕ
	|	НЕ ФизическиеЛица.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	НайденныеСтроки.КодБОСС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НайденныеСтроки.КодБОСС КАК КодБОСС,
	|	НайденныеСтроки.ТабельныйНомер КАК ТабельныйНомер,
	|	НайденныеСтроки.Фамилия КАК Фамилия,
	|	НайденныеСтроки.Имя КАК Имя,
	|	НайденныеСтроки.Отчество КАК Отчество,
	|	ЕСТЬNULL(ФизическиеЛица.ФизическоеЛицо, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК ФизическоеЛицо,
	|	НайденныеСтроки.Должность КАК Должность,
	|	НайденныеСтроки.Объект КАК Объект,
	|	НайденныеСтроки.ДатаРождения КАК ДатаРождения,
	|	НайденныеСтроки.ДатаПриема КАК ДатаПриема,
	|	НайденныеСтроки.ДатаУвольнения КАК ДатаУвольнения,
	|	НайденныеСтроки.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА НайденныеСтроки.Пол = 0
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Мужской)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Женский)
	|	КОНЕЦ КАК Пол,
	|	НайденныеСтроки.ДатаПеревода КАК ДатаПеревода
	|ИЗ
	|	НайденныеСтроки КАК НайденныеСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ФизическиеЛица КАК ФизическиеЛица
	|		ПО НайденныеСтроки.КодБОСС = ФизическиеЛица.КодБОСС";
	
	НайденныеСтроки	=	Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТаблицыЗначений Из НайденныеСтроки Цикл
		Если Не ЗначениеЗаполнено(СтрокаТаблицыЗначений.ФизическоеЛицо) Тогда
			ОбщегоНазначения.СообщитьПользователю("Физическое лицо по коду БОСС не найдено: " + СтрокаТаблицыЗначений.КодБОСС);
		КонецЕсли;
	КонецЦикла;
	
	Возврат НайденныеСтроки;
	
КонецФункции

Функция Мэппинг(НайденныеСтроки)
	
	ФорматироватьТаблицуЗначений(НайденныеСтроки);
	
	МенеджерВременныхТаблиц	=	Новый МенеджерВременныхТаблиц;
	
	Запрос	=	Новый Запрос;
	Запрос.МенеджерВременныхТаблиц	=	МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("НайденныеСтроки", 	НайденныеСтроки);
	Запрос.УстановитьПараметр("Источник", 			ПолучитьИсточник());
	//Запрос.УстановитьПараметр("Организация", 		Организация);
	//Запрос.УстановитьПараметр("ДатаСреза", 			ТекущаяДатаСеанса());
	
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	НайденныеСтроки.ДатаПеревода КАК ДатаПеревода,
	|	НайденныеСтроки.КодБОСССтрока КАК КодБОСС,
	|	НайденныеСтроки.ТабельныйНомер КАК ТабельныйНомер,
	|	НайденныеСтроки.Фамилия КАК Фамилия,
	|	НайденныеСтроки.Имя КАК Имя,
	|	НайденныеСтроки.Отчество КАК Отчество,
	|	НайденныеСтроки.Должность КАК Должность,
	|	НайденныеСтроки.Объект КАК Объект,
	|	НайденныеСтроки.ДатаРождения КАК ДатаРождения,
	|	НайденныеСтроки.ДатаПриема КАК ДатаПриема,
	|	НайденныеСтроки.ДатаУвольнения КАК ДатаУвольнения,
	|	НайденныеСтроки.ЦФО КАК ЦФО,
	|	НайденныеСтроки.БИК КАК БИК,
	|	НайденныеСтроки.НомерСчета КАК НомерСчета,
	|	НайденныеСтроки.СерияДокумента КАК СерияДокумента,
	|	НайденныеСтроки.НомерДокумента КАК НомерДокумента,
	|	НайденныеСтроки.ДатаПолучения КАК ДатаПолучения,
	|	НайденныеСтроки.КемВыдан КАК КемВыдан,
	|	НайденныеСтроки.Гражданство КАК Гражданство,
	|	НайденныеСтроки.Организация КАК Организация,
	|	НайденныеСтроки.КодПриемаНаРаботу КАК КодПриемаНаРаботу,
	|	НайденныеСтроки.Пол КАК Пол,
	|	НайденныеСтроки.Загружен КАК Загружен
	|ПОМЕСТИТЬ НайденныеСтроки
	|ИЗ
	|	&НайденныеСтроки КАК НайденныеСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ФизическиеЛица.Ссылка) КАК ФизическоеЛицо,
	|	НайденныеСтроки.КодБОСС КАК КодБОСС
	|ПОМЕСТИТЬ ФизическиеЛица
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НайденныеСтроки КАК НайденныеСтроки
	|		ПО ФизическиеЛица.ок_КодФизическогоЛицаБОСС = НайденныеСтроки.КодБОСС
	|ГДЕ
	|	НЕ ФизическиеЛица.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	НайденныеСтроки.КодБОСС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НайденныеСтроки.ДатаПеревода КАК ДатаПеревода,
	|	НайденныеСтроки.КодБОСС КАК КодБОСС,
	|	НайденныеСтроки.ТабельныйНомер КАК ТабельныйНомер,
	|	НайденныеСтроки.Фамилия КАК Фамилия,
	|	НайденныеСтроки.Имя КАК Имя,
	|	НайденныеСтроки.Отчество КАК Отчество,
	|	ЕСТЬNULL(ФизическиеЛица.ФизическоеЛицо, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК ФизическоеЛицо,
	|	НайденныеСтроки.Должность КАК Должность,
	|	НайденныеСтроки.Объект КАК ОбъектКод,
	|	МАКСИМУМ(ЕСТЬNULL(ок_СопоставлениеАналитикиДляИнтеграцийОбъект.Аналитика1С, ЗНАЧЕНИЕ(Справочник.ОбъектыСтроительства.ПустаяСсылка))) КАК Объект,
	|	НайденныеСтроки.ДатаРождения КАК ДатаРождения,
	|	НайденныеСтроки.ДатаПриема КАК ДатаПриема,
	|	НайденныеСтроки.ДатаУвольнения КАК ДатаУвольнения,
	|	НайденныеСтроки.ЦФО КАК ФункцияКод,
	|	МАКСИМУМ(ЕСТЬNULL(ок_СопоставлениеАналитикиДляИнтеграцийЦФО.Аналитика1С, ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка))) КАК Функция,
	|	НайденныеСтроки.БИК КАК БИК,
	|	НайденныеСтроки.НомерСчета КАК НомерСчета,
	|	НайденныеСтроки.СерияДокумента КАК СерияДокумента,
	|	НайденныеСтроки.НомерДокумента КАК НомерДокумента,
	|	НайденныеСтроки.ДатаПолучения КАК ДатаПолучения,
	|	НайденныеСтроки.КемВыдан КАК КемВыдан,
	|	НайденныеСтроки.Гражданство КАК Гражданство,
	|	НайденныеСтроки.Организация КАК ОрганизацияКод,
	|	МАКСИМУМ(ЕСТЬNULL(ок_СопоставлениеАналитикиДляИнтеграцийОрганизация.Аналитика1С, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))) КАК Организация,
	|	НайденныеСтроки.КодПриемаНаРаботу КАК КодПриемаНаРаботу,
	|	ВЫБОР
	|		КОГДА НайденныеСтроки.Пол = 0
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Мужской)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Женский)
	|	КОНЕЦ КАК Пол,
	|	НайденныеСтроки.Загружен КАК Загружен
	|ПОМЕСТИТЬ ДанныеБОСС
	|ИЗ
	|	НайденныеСтроки КАК НайденныеСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ФизическиеЛица КАК ФизическиеЛица
	|		ПО НайденныеСтроки.КодБОСС = ФизическиеЛица.КодБОСС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ок_СопоставлениеАналитикиДляИнтеграций КАК ок_СопоставлениеАналитикиДляИнтеграцийЦФО
	|		ПО НайденныеСтроки.ЦФО = ок_СопоставлениеАналитикиДляИнтеграцийЦФО.АналитикаИсточника
	|			И (ок_СопоставлениеАналитикиДляИнтеграцийЦФО.Источник = &Источник)
	|			И (ок_СопоставлениеАналитикиДляИнтеграцийЦФО.Тип1С.ВидОбъекта = ЗНАЧЕНИЕ(Перечисление.бит_ВидыОбъектовСистемы.Справочник))
	|			И (ок_СопоставлениеАналитикиДляИнтеграцийЦФО.Тип1С.ИмяОбъекта = ""Подразделения"")
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ок_СопоставлениеАналитикиДляИнтеграций КАК ок_СопоставлениеАналитикиДляИнтеграцийОбъект
	|		ПО НайденныеСтроки.Объект = ок_СопоставлениеАналитикиДляИнтеграцийОбъект.АналитикаИсточника
	|			И (ок_СопоставлениеАналитикиДляИнтеграцийОбъект.Источник = &Источник)
	|			И (ок_СопоставлениеАналитикиДляИнтеграцийОбъект.Тип1С.ВидОбъекта = ЗНАЧЕНИЕ(Перечисление.бит_ВидыОбъектовСистемы.Справочник))
	|			И (ок_СопоставлениеАналитикиДляИнтеграцийОбъект.Тип1С.ИмяОбъекта = ""ОбъектыСтроительства"")
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ок_СопоставлениеАналитикиДляИнтеграций КАК ок_СопоставлениеАналитикиДляИнтеграцийОрганизация
	|		ПО (ок_СопоставлениеАналитикиДляИнтеграцийОрганизация.Источник = &Источник)
	|			И (ок_СопоставлениеАналитикиДляИнтеграцийОрганизация.Тип1С.ВидОбъекта = ЗНАЧЕНИЕ(Перечисление.бит_ВидыОбъектовСистемы.Справочник))
	|			И (ок_СопоставлениеАналитикиДляИнтеграцийОрганизация.Тип1С.ИмяОбъекта = ""Организации"")
	|			И НайденныеСтроки.Организация = ок_СопоставлениеАналитикиДляИнтеграцийОрганизация.АналитикаИсточника
	|
	|СГРУППИРОВАТЬ ПО
	|	НайденныеСтроки.ДатаПеревода,
	|	НайденныеСтроки.КодБОСС,
	|	НайденныеСтроки.ТабельныйНомер,
	|	НайденныеСтроки.Фамилия,
	|	НайденныеСтроки.Имя,
	|	НайденныеСтроки.Отчество,
	|	ЕСТЬNULL(ФизическиеЛица.ФизическоеЛицо, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)),
	|	НайденныеСтроки.Должность,
	|	НайденныеСтроки.Объект,
	|	НайденныеСтроки.ДатаРождения,
	|	НайденныеСтроки.ДатаПриема,
	|	НайденныеСтроки.ДатаУвольнения,
	|	НайденныеСтроки.ЦФО,
	|	НайденныеСтроки.БИК,
	|	НайденныеСтроки.НомерСчета,
	|	НайденныеСтроки.СерияДокумента,
	|	НайденныеСтроки.НомерДокумента,
	|	НайденныеСтроки.ДатаПолучения,
	|	НайденныеСтроки.КемВыдан,
	|	НайденныеСтроки.Гражданство,
	|	НайденныеСтроки.Организация,
	|	НайденныеСтроки.КодПриемаНаРаботу,
	|	ВЫБОР
	|		КОГДА НайденныеСтроки.Пол = 0
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Мужской)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Женский)
	|	КОНЕЦ,
	|	НайденныеСтроки.Загружен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеБОСС.ДатаПеревода КАК Период,
	|	ДанныеБОСС.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеБОСС.ТабельныйНомер КАК ТабельныйНомер,
	|	ДанныеБОСС.Организация КАК Организация,
	|	ДанныеБОСС.КодБОСС КАК КодБОСС,
	|	ДанныеБОСС.Фамилия КАК Фамилия,
	|	ДанныеБОСС.Имя КАК Имя,
	|	ДанныеБОСС.Отчество КАК Отчество,
	|	ДанныеБОСС.ДатаРождения КАК ДатаРождения,
	|	ДанныеБОСС.Гражданство КАК Гражданство,
	|	ДанныеБОСС.СерияДокумента КАК СерияДокумента,
	|	ДанныеБОСС.НомерДокумента КАК НомерДокумента,
	|	ДанныеБОСС.ДатаПолучения КАК ДатаВыдачиДокумента,
	|	ДанныеБОСС.КемВыдан КАК КемВыданДокумент,
	|	ДанныеБОСС.Должность КАК Должность,
	|	ДанныеБОСС.Функция КАК Функция,
	|	ДанныеБОСС.Объект КАК Объект,
	|	ДанныеБОСС.ДатаПриема КАК ДатаПриема,
	|	ДанныеБОСС.ДатаУвольнения КАК ДатаУвольнения,
	|	ДанныеБОСС.КодПриемаНаРаботу КАК КодПриемаНаРаботу,
	|	ДанныеБОСС.БИК КАК БИКБанка,
	|	ДанныеБОСС.НомерСчета КАК НомерРасчетногоСчета,
	|	ДанныеБОСС.ФункцияКод КАК ФункцияКод,
	|	ДанныеБОСС.ОбъектКод КАК ОбъектКод,
	//ОКЕЙ Первухин В.С. (ПервыйБИТ) Начало 2021-11-09 (#AT-2155019)
	|	ДанныеБОСС.ОрганизацияКод КАК ОрганизацияКод,
	//ОКЕЙ Первухин В.С. (ПервыйБИТ) Конец 2021-11-09 (#AT-2155019)
	|	НЕ ДанныеБОСС.Фамилия = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.Фамилия, """")
	|		ИЛИ НЕ ДанныеБОСС.Имя = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.Имя, """")
	|		ИЛИ НЕ ДанныеБОСС.Отчество = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.Отчество, """")
	|		ИЛИ НЕ ДанныеБОСС.ДатаРождения = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.ДатаРождения, ДАТАВРЕМЯ(1, 1, 1))
	|		ИЛИ НЕ ДанныеБОСС.Гражданство = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.Гражданство, """")
	|		ИЛИ НЕ ДанныеБОСС.СерияДокумента = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.СерияДокумента, """")
	|		ИЛИ НЕ ДанныеБОСС.НомерДокумента = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.НомерДокумента, """")
	|		ИЛИ НЕ ДанныеБОСС.ДатаПолучения = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.ДатаВыдачиДокумента, ДАТАВРЕМЯ(1, 1, 1))
	|		ИЛИ НЕ ДанныеБОСС.КемВыдан = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.КемВыданДокумент, """")
	|		ИЛИ НЕ ДанныеБОСС.Должность = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.Должность, """")
	|		ИЛИ НЕ ДанныеБОСС.Функция = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.Функция, ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка))
	|		ИЛИ НЕ ДанныеБОСС.Объект = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.Объект, ЗНАЧЕНИЕ(Справочник.ОбъектыСтроительства.ПустаяСсылка))
	|		ИЛИ НЕ ДанныеБОСС.ДатаПриема = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.ДатаПриема, ДАТАВРЕМЯ(1, 1, 1))
	|		ИЛИ НЕ ДанныеБОСС.ДатаУвольнения = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.ДатаУвольнения, ДАТАВРЕМЯ(1, 1, 1))
	|		ИЛИ НЕ ДанныеБОСС.КодПриемаНаРаботу = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.КодПриемаНаРаботу, 0)
	|		ИЛИ НЕ ДанныеБОСС.БИК = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.БИКБанка, """")
	|		ИЛИ НЕ ДанныеБОСС.НомерСчета = ЕСТЬNULL(ок_ДанныеФизическихЛицБОСССрезПоследних.НомерРасчетногоСчета, """") КАК ЕстьИзменения
	|ИЗ
	|	ДанныеБОСС КАК ДанныеБОСС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ок_ДанныеФизическихЛицБОСС.СрезПоследних(, ) КАК ок_ДанныеФизическихЛицБОСССрезПоследних
	|		ПО ДанныеБОСС.ФизическоеЛицо = ок_ДанныеФизическихЛицБОСССрезПоследних.ФизическоеЛицо
	|			И ДанныеБОСС.ТабельныйНомер = ок_ДанныеФизическихЛицБОСССрезПоследних.ТабельныйНомер
	|			И ДанныеБОСС.Организация = ок_ДанныеФизическихЛицБОСССрезПоследних.Организация
	|			И ДанныеБОСС.КодБОСС = ок_ДанныеФизическихЛицБОСССрезПоследних.КодБОСС";
	Результат	=	Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка	=	Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не Выборка.ЕстьИзменения Тогда
				Продолжить;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Выборка.Организация) Тогда
				ОбщегоНазначения.СообщитьПользователю("Не найдено соответствие для организации: " + Выборка.ОрганизацияКод);
				Продолжить; // Так как это измерение.
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Выборка.Функция) Тогда
				ОбщегоНазначения.СообщитьПользователю("Не найдено соответствие для функции: " + Выборка.ФункцияКод);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Выборка.Объект) Тогда
				ОбщегоНазначения.СообщитьПользователю("Не найдено соответствие для объекта: " + Выборка.ОбъектКод);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Выборка.ФизическоеЛицо) Тогда
				ОбщегоНазначения.СообщитьПользователю("Физическое лицо по коду БОСС не найдено: " + Выборка.КодБОСС);
			КонецЕсли;
			
			МенеджерЗаписи	=	РегистрыСведений.ок_ДанныеФизическихЛицБОСС.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
			МенеджерЗаписи.Записать();
			
		КонецЦикла;
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти