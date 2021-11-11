﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ВСДРасширеннаяЭтикетка") Тогда
		СтруктураТипов = ИнтеграцияИС.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ВСДРасширеннаяЭтикетка",
			НСтр("ru='ВСД, расширенная этикетка'"),
			СформироватьПечатнуюФормуВСДРасширеннаяЭтикетка(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ВСДСжатаяЭтикетка") Тогда
		СтруктураТипов = ИнтеграцияИС.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ВСДСжатаяЭтикетка",
			НСтр("ru='ВСД, сжатая этикетка'"),
			СформироватьПечатнуюФормуВСДСжатаяЭтикетка(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

#КонецОбласти

#Область ЭтикеткиВЕТИС

Функция СформироватьПечатнуюФормуВСДРасширеннаяЭтикетка(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВСДРАСШИРЕННАЯЭТИКЕТКА";
	
	НомерТипаДокумента = 0;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыРасширеннойЭтикеткиВСД(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументВСДРасширеннаяЭтикетка(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуВСДСжатаяЭтикетка(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВСДСЖАТАЯЭТИКЕТКА";
	
	НомерТипаДокумента = 0;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыСжатойЭтикеткиВСД(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументВСДСжатаяЭтикетка(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументВСДРасширеннаяЭтикетка(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати)
	
	ДанныеПечати = ДанныеДляПечати.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если ДанныеПечати.Количество() = 0 Тогда
		
		ОтметитьПечатьНеТребуется(ТабличныйДокумент);
		
	КонецЕсли;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Макет = Новый ТабличныйДокумент;
		
		ДанныеВСД = ДанныеПечати.Выбрать();
		Пока ДанныеВСД.Следующий() Цикл 
			ЗаполнитьРеквизитыШапкиВСДРасширеннаяЭтикетка(ДанныеВСД, Макет, ТабличныйДокумент);
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьТабличныйДокументВСДСжатаяЭтикетка(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати, Присоединить = Ложь)
	
	ДанныеПечати = ДанныеДляПечати.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	НомерВСтроке = 0;
	
	Если ДанныеПечати.Количество() = 0 Тогда
		
		ОтметитьПечатьНеТребуется(ТабличныйДокумент);
		
	КонецЕсли;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Макет = Новый ТабличныйДокумент;
		
		ДанныеВСД = ДанныеПечати.Выбрать();
		Пока ДанныеВСД.Следующий() Цикл
			ЗаполнитьРеквизитыШапкиВСДСжатаяЭтикетка(ДанныеВСД, Макет, ТабличныйДокумент, НомерВСтроке);
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыШапкиВСДРасширеннаяЭтикетка(ДанныеПечати, Макет, ТабличныйДокумент)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьЭтикетокВЕТИС.ПФ_MXL_ВСДРасширеннаяЭтикетка");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Этикетка");
	
	ВывестиQRКод(ДанныеПечати,ОбластьМакета);
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	ОбластьМакета.Параметры.ДатаДокумента = Формат(ДанныеПечати.ДатаДокумента,"ДЛФ=D");
	ОбластьМакета.Параметры.ДатаПроизводстваПредставление = ИнтеграцияВЕТИСКлиентСервер.ПредставлениеПериодаВЕТИС(
		ДанныеПечати.ДатаПроизводстваТочностьЗаполнения,
		ДанныеПечати.ДатаПроизводстваНачалоПериода,
		ДанныеПечати.ДатаПроизводстваКонецПериода,
		ДанныеПечати.ДатаПроизводстваСтрока);
	Если ЗначениеЗаполнено(ДанныеПечати.ТипТТН)Тогда 
		ОбластьМакета.Параметры.ДанныеТТН = СтрШаблон(НСтр("ru = ', %1: № %2 %3 от %4'"),
			ДанныеПечати.ТипТТН,
			ДанныеПечати.СерияТТН,
			ДанныеПечати.НомерТТН,
			Формат(ДанныеПечати.ДатаТТН,"ДЛФ=D"));
	КонецЕсли;
	
	Производители = ДанныеПечати.Производители.Выбрать();
	
	Если Производители.Количество() = 1 Тогда
		Производители.Следующий();
	
		ТаблицаПроизводители = Новый ТаблицаЗначений;
		ТаблицаПроизводители.Колонки.Добавить("Производитель");
		ТаблицаПроизводители.Колонки.Добавить("НомераПредприятий");
		СтрокаПроизводитель = ТаблицаПроизводители.Добавить();
		СтрокаПроизводитель.Производитель = Производители.ПроизводительПредприятие;
		Справочники.ПредприятияВЕТИС.ЗаполнитьНомера(ТаблицаПроизводители);
		Если ЗначениеЗаполнено(СтрокаПроизводитель.НомераПредприятий) Тогда
			ОбластьМакета.Параметры.ПроизводительПредприятиеАдрес = СтрШаблон(
				НСтр("ru = ',[%1] %2 (%3)'"),
				СтрокаПроизводитель.НомераПредприятий,
				Производители.ПроизводительПредприятие,
				Производители.ПроизводительПредприятиеАдрес);
		Иначе
			ОбластьМакета.Параметры.ПроизводительПредприятиеАдрес = СтрШаблон(
				НСтр("ru = ',%1 (%2)'"),
				Производители.ПроизводительПредприятие,
				Производители.ПроизводительПредприятиеАдрес);
		КонецЕсли;
	
	ИначеЕсли Производители.Количество() > 1 Тогда
		ОбластьМакета.Параметры.ПроизводительПредприятиеАдрес = 
			" "
			+ НСтр("ru = '(Несколько производителей)'");
	КонецЕсли;
	ОбластьМакета.Параметры.Идентификатор = ИдентификаторПоЧетыреЗнака(ДанныеПечати.Идентификатор);
	ОбластьМакета.Параметры.ДатаПечати = ТекущаяДатаСеанса();
	ОбластьМакета.Параметры.ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	Если НЕ ТабличныйДокумент.ПроверитьВывод(ОбластьМакета)Тогда 
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыШапкиВСДСжатаяЭтикетка(ДанныеПечати, Макет, ТабличныйДокумент, НомерВСтроке)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьЭтикетокВЕТИС.ПФ_MXL_ВСДСжатаяЭтикетка");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Этикетка");
	
	ВывестиQRКод(ДанныеПечати,ОбластьМакета);
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	
	ОбластьМакета.Параметры.Идентификатор       = ИдентификаторПоЧетыреЗнака(ДанныеПечати.Идентификатор);
	ОбластьМакета.Параметры.ДатаПечати          = ТекущаяДатаСеанса();
	ОбластьМакета.Параметры.ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	
	Если НомерВСтроке<>КоличествоСжатыхЭтикетокПоГоризонтали() Тогда
		НомерВСтроке = НомерВСтроке + 1;
		ТабличныйДокумент.Присоединить(ОбластьМакета);
		Возврат;
	КонецЕсли;
	
	НомерВСтроке = 1;
	Если НЕ ТабличныйДокумент.ПроверитьВывод(ОбластьМакета)Тогда 
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

Процедура ОтметитьПечатьНеТребуется(ТабличныйДокумент)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьЭтикетокВЕТИС.ПФ_MXL_НетДанныхДляПечати");
	ТабличныйДокумент.Вывести(Макет);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Прочее

Процедура ВывестиQRКод(ДанныеПечати, ОбластьМакета)
	
	QRСтрока = ИнтеграцияВЕТИСКлиентСервер.ПутьКСерверуСИнформациейПоВСД() + ДанныеПечати.Идентификатор;
	
	Если Не ПустаяСтрока(QRСтрока) Тогда
		
		ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRСтрока, 0, 190);
		
		Если ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
			КартинкаQRКода = Новый Картинка(ДанныеQRКода);
			ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаQRКода;
		Иначе
			Шаблон = Нстр("ru = 'Не удалось сформировать QR-код для документа %1.
				|Технические подробности см. в журнале регистрации.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИдентификаторПоЧетыреЗнака(Знач Идентификатор)
	
	Идентификатор = ВРег(СтрЗаменить(Идентификатор,"-",""));
	Результат = "";
	Пока Идентификатор<>"" Цикл
		Группа = Лев(Идентификатор,4);
		Результат = Результат + "-" + Группа;
		Идентификатор = Сред(Идентификатор,5);
	КонецЦикла;
	Возврат Сред(Результат,2);
	
КонецФункции

Функция КоличествоСжатыхЭтикетокПоГоризонтали()
	Возврат 2;
КонецФункции

#КонецОбласти

#КонецЕсли
