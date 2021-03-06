Функция СведенияОВнешнейОбработке() Экспорт
	
	РегистрационныеДанные = Новый Структура;
	РегистрационныеДанные.Вставить("Наименование", "Взаиморасчеты по аренде");
	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
	РегистрационныеДанные.Вставить("Версия", "1.00");
	
	РегистрационныеДанные.Вставить("Вид", "ДополнительныйОтчет");
	
	РегистрационныеДанные.Вставить("Информация", "Взаиморасчеты по аренде");
	
	///////////// команды /////////////////////////
	тзКоманд = Новый ТаблицаЗначений;
	тзКоманд.Колонки.Добавить("Идентификатор");
	тзКоманд.Колонки.Добавить("Представление");
	тзКоманд.Колонки.Добавить("Модификатор");
	тзКоманд.Колонки.Добавить("ПоказыватьОповещение");
	тзКоманд.Колонки.Добавить("Использование");
	
	строкаКоманды = тзКоманд.Добавить();
	строкаКоманды.Идентификатор = "1";
	строкаКоманды.Представление = "Взаиморасчеты по аренде";
	строкаКоманды.ПоказыватьОповещение = Истина;
	строкаКоманды.Использование = "ОткрытиеФормы";
	
	РегистрационныеДанные.Вставить("Команды", тзКоманд);
	
	Возврат РегистрационныеДанные;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ - ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА.

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
		   			
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	ПередКомпоновкойМакета();
	НастройкиКН = КомпоновщикНастроек.ПолучитьНастройки();
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКН, ДанныеРасшифровки);
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,,ДанныеРасшифровки);
		
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ОбновитьПараметризуемыеЗаголовкиПолей(ДокументРезультат, НастройкиКН);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПередКомпоновкойМакета()
	
	СчетаУчетаРасчетов = БухгалтерскиеОтчеты.СчетаУчетаРасчетовПокупателей();
	
	ПредопределенныеСчетаАвансов = Новый Массив;
	ПредопределенныеСчетаАвансов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученным);    // 62.02
	ПредопределенныеСчетаАвансов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученнымВал); // 62.22
	ПредопределенныеСчетаАвансов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученнымУЕ);  // 62.32
	СчетаАвансов = БухгалтерскийУчет.СформироватьМассивСубсчетов(ПредопределенныеСчетаАвансов);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаАвансов", 				СчетаАвансов);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаСДокументомРасчетов", 	СчетаУчетаРасчетов.СчетаСДокументомРасчетов);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаБезДокументаРасчетов", 	СчетаУчетаРасчетов.СчетаБезДокументаРасчетов);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидыДоговоров", БухгалтерскиеОтчеты.ВидыДоговоровПокупателей());
		
	ОсновнаяСтатьяОборотовПоАренде 	= ОК_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("Аренда", "ОсновнаяСтатьяОборотовПоАренде", ПредопределенноеЗначение("Справочник.бит_СтатьиОборотов.ПустаяСсылка"));
	ВидАП 							= ОК_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("Аренда", "ВидАП", 	Неопределено);
	ПериодАП 						= ОК_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("Аренда", "ПериодАП", 	Неопределено);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОсновнаяСтатьяОборотовПоАренде", 	ОсновнаяСтатьяОборотовПоАренде);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидАП", 							ВидАП);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПериодАП", 						ПериодАП);
	
КонецПроцедуры

Процедура ОбновитьПараметризуемыеЗаголовкиПолей(ДокументРезультат, НастройкиКН)
	
	СтруктураПараметров = Новый Структура;
	Для каждого ТекущийПараметр Из НастройкиКН.ПараметрыДанных.Элементы Цикл
		
		СтруктураПараметров.Вставить(Строка(ТекущийПараметр.Параметр), ТекущийПараметр.Значение);
		
	КонецЦикла;
	
	ПослеВыводаРезультата(СтруктураПараметров, ДокументРезультат);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	ОбластьЯчеек = Результат.НайтиТекст("<НачалоПериода>");
	Если ОбластьЯчеек <> Неопределено Тогда
		
		ТекстЯчейки = НСтр("ru = 'Расчеты на %1'");
		
		ОбластьЯчеек.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЯчейки, Формат(ПараметрыОтчета.ПериодОтчета.ДатаНачала, "ДФ=dd.MM.yy; ДП=..."));;
		ОбластьЯчеек = Результат.Область(ОбластьЯчеек.Верх, ОбластьЯчеек.Лево, ОбластьЯчеек.Верх + 1, ОбластьЯчеек.Лево + 7);
		ОбластьЯчеек.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		
	КонецЕсли;
		
	ОбластьЯчеек = Результат.НайтиТекст("<КонецПериода>");
	Если ОбластьЯчеек <> Неопределено Тогда
		
		ТекстЯчейки = НСтр("ru = 'Расчеты на %1'");
		
		ОбластьЯчеек.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЯчейки, Формат(ПараметрыОтчета.ПериодОтчета.ДатаОкончания, "ДФ=dd.MM.yy; ДП=..."));
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли