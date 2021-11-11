﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекНастройки  = КомпоновщикНастроек.ПолучитьНастройки();
	
	//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-07 (#3775)
	ОтборОЦР = Справочники.бит_БК_Инициаторы.ПустаяСсылка();
	Если ЭтотОбъект.ТолстыйКлиент Тогда
		ОтборОЦР = ПроверитьОбязательныеОтборы(ТекНастройки.Отбор);
		Если НЕ ЗначениеЗаполнено(ОтборОЦР) Тогда
			Возврат;	
		КонецЕсли; 
	КонецЕсли;
	//ОКЕЙ Морозов А.В. (СофтЛаб) Конец  2020-09-07 (#3775)

	//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-07 (#3775)
	//Если НЕ ПроверитьКомбинацииНастроекНаДоступность(ТекНастройки.Отбор) Тогда 
		
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Вы не являетесь ОЦР по указанному сочетанию аналитик. 
		//															 |Внесите изменения в установленные отборы по аналитикам и сформируйте отчет повторно.'"));
	Если НЕ ПроверитьКомбинацииНастроекНаДоступность(ТекНастройки.Отбор, ОтборОЦР) Тогда 
		Если ЭтотОбъект.ТолстыйКлиент Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Инициатор не является ОЦР по указанному сочетанию аналитик. 
																		 |Внесите изменения в установленные отборы и сформируйте отчет повторно.'"));
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Вы не являетесь ОЦР по указанному сочетанию аналитик. 
																		 |Внесите изменения в установленные отборы по аналитикам и сформируйте отчет повторно.'"));
		КонецЕсли;	
	//ОКЕЙ Морозов А.В. (СофтЛаб) Конец 2020-09-07 (#3775)
		
		Возврат;
	КонецЕсли;
	
	ПериодОтчета  = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ТекНастройки, "ПериодОтчета").Значение;
	
	пСохрПериодОтчета = Новый СтандартныйПериод;
	ЗаполнитьЗначенияСвойств(пСохрПериодОтчета, ПериодОтчета);
	
	ПриводитьДатуКГоду = СписокВидовСтатейДоступныхИнициатору.НайтиПоЗначению(ПредопределенноеЗначение("Справочник.бит_ВидыСтатейОборотов.ИнвестиционнаяДеятельность")) <> Неопределено;
	
	ПериодДляВывода = Новый СтандартныйПериод;
	
	ПериодДляВывода.ДатаНачала = НачалоГода(ПериодОтчета.ДатаНачала);
	ПериодДляВывода.ДатаОкончания = КонецГода(ПериодОтчета.ДатаОкончания);
	Если НЕ ПриводитьДатуКГоду Тогда 
		Если Месяц(ПериодОтчета.ДатаНачала)>6 Тогда 
			ПериодДляВывода.ДатаНачала	  = ДобавитьМесяц(ПериодДляВывода.ДатаНачала, 6);		
		КонецЕсли;
		Если Месяц(ПериодОтчета.ДатаОкончания)<7 Тогда 
			ПериодДляВывода.ДатаОкончания = ДобавитьМесяц(ПериодДляВывода.ДатаОкончания, -6);
		КонецЕсли;
	КонецЕсли;
			
	Настройки = СхемаКомпоновкиДанных.ВариантыНастроек["ДляВыбораГруппировки"].Настройки;
	
	КомпоновщикДляВыбораГруппировки = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикДляВыбораГруппировки.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикДляВыбораГруппировки.ЗагрузитьНастройки(Настройки);
	
	//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-07 (#3775)
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикДляВыбораГруппировки, "ОЦР", ПараметрыСеанса.бит_бк_ТекущийИнициатор, Истина);
	Если ЭтотОбъект.ТолстыйКлиент  Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикДляВыбораГруппировки, "ОЦР", ОтборОЦР, Истина);
	Иначе 	
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикДляВыбораГруппировки, "ОЦР", ПараметрыСеанса.бит_бк_ТекущийИнициатор, Истина);
	КонецЕсли;
	//ОКЕЙ Морозов А.В. (СофтЛаб) Конец 2020-09-07 (#3775)
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикДляВыбораГруппировки, "ПериодОтчета", ПериодДляВывода, Истина);	
		
	КомпоновщикДляВыбораГруппировки.Настройки.Отбор.Элементы.Очистить();
    Для Каждого НастройкаОтбора Из ТекНастройки.Отбор.Элементы Цикл 
        НовСтрока = КомпоновщикДляВыбораГруппировки.Настройки.Отбор.Элементы.Добавить(ТипЗнч(НастройкаОтбора));
        ЗаполнитьЗначенияСвойств(НовСтрока,НастройкаОтбора);
    КонецЦикла;
	  						
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикДляВыбораГруппировки.ПолучитьНастройки(), ,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ТаблицаДляВыводаГруппировки = Новый ТаблицаЗначений;
	
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаДляВыводаГруппировки);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
	ИмяВарианта = "ГруппировкаУниверсальная";
	
	пДатаНачала	   = НачалоГода(ПериодОтчета.ДатаНачала);
	пДатаОкончания = КонецГода(ПериодОтчета.ДатаОкончания);
	
	Если ТаблицаДляВыводаГруппировки.Количество()=1 Тогда 
			
		ИмяВарианта = "ГруппировкаИнвестОпер";
		
		Если ТаблицаДляВыводаГруппировки[0].ВидСтатьиОборотов = ПредопределенноеЗначение("Справочник.бит_ВидыСтатейОборотов.Выручка") Тогда 
			Если Месяц(ПериодОтчета.ДатаНачала)>6 Тогда 
				пДатаНачала	  = ДобавитьМесяц(пДатаНачала, 6);		
			КонецЕсли;
			Если Месяц(ПериодОтчета.ДатаОкончания)<7 Тогда 
				пДатаОкончания = ДобавитьМесяц(пДатаОкончания, -6);
			КонецЕсли;
		КонецЕсли;
						
	КонецЕсли;
	
	Если ТаблицаДляВыводаГруппировки.Количество() = 0 Тогда 
		ЗаполнитьЗначенияСвойств(ПериодОтчета, ПериодДляВывода);
	Иначе 
		ПериодОтчета.ДатаНачала	   = пДатаНачала;
		ПериодОтчета.ДатаОкончания = пДатаОкончания;		
	КонецЕсли;
	
	Настройки = СхемаКомпоновкиДанных.ВариантыНастроек[ИмяВарианта].Настройки;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
    Для Каждого НастройкаОтбора Из ТекНастройки.Отбор.Элементы Цикл 
        НовСтрока = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(ТипЗнч(НастройкаОтбора));
        ЗаполнитьЗначенияСвойств(НовСтрока,НастройкаОтбора);
    КонецЦикла;
		
	//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-07 (#3775)
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОЦР", ПараметрыСеанса.бит_бк_ТекущийИнициатор, Истина);
	Если ЭтотОбъект.ТолстыйКлиент  Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОЦР", ОтборОЦР, Истина);	
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОЦР", ПараметрыСеанса.бит_бк_ТекущийИнициатор, Истина);
	КонецЕсли;
	//ОКЕЙ Морозов А.В. (СофтЛаб) Конец 2020-09-07 (#3775)

	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПериодОтчета", ПериодОтчета, Истина);	
		
	ДокументРезультат.Очистить();
					
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки());
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
		
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ДокументРезультат.ПоказатьУровеньГруппировокКолонок(0);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПериодОтчета", пСохрПериодОтчета, Истина);	        
	
	ДокументРезультат.АвтоМасштаб = Истина;
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
			
КонецПроцедуры

//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-07 (#3775)
//Функция ПроверитьКомбинацииНастроекНаДоступность(Знач ОтборСКД)
Функция ПроверитьКомбинацииНастроекНаДоступность(Знач ОтборСКД, ОтборОЦР)
//ОКЕЙ Морозов А.В. (СофтЛаб) Конец 2020-09-07 (#3775)
	
	БылУстановленПривелегированныйРежим = Ложь;
	Если НЕ ПривилегированныйРежим() Тогда 
		УстановитьПривилегированныйРежим(Истина);
		БылУстановленПривелегированныйРежим = Истина;
	КонецЕсли;
		
	СКД = ПолучитьМакет("СКД_ПроверкиОграничений");
					
	Настройки = СКД.НастройкиПоУмолчанию;
	
	Настройки.Отбор.Элементы.Очистить();
	
	пКДЦФО = Новый ПолеКомпоновкиДанных("ЦФО");
	пКДОбс = Новый ПолеКомпоновкиДанных("ОбъектСтроительства");
	пКДСтО = Новый ПолеКомпоновкиДанных("СтатьяОборотовКонтролируемая");
	
	Для Каждого ЭлОтбора Из ОтборСКД.Элементы Цикл 
		Если НЕ ЭлОтбора.Использование
		   ИЛИ (ЭлОтбора.ЛевоеЗначение <> пКДЦФО
		   И ЭлОтбора.ЛевоеЗначение <> пКДОбс
		   И ЭлОтбора.ЛевоеЗначение <> пКДСтО)
		Тогда 
			Продолжить;	
		КонецЕсли;
		
		НовЭлОтбора = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЗаполнитьЗначенияСвойств(НовЭлОтбора, ЭлОтбора);
		
	КонецЦикла;

	//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-07 (#3775)
	//БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Настройки, "ОЦР", ПараметрыСеанса.бит_бк_ТекущийИнициатор, Истина);
	Если ЭтотОбъект.ТолстыйКлиент Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Настройки, "ОЦР", ОтборОЦР, Истина);
	Иначе 
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Настройки, "ОЦР", ПараметрыСеанса.бит_бк_ТекущийИнициатор, Истина);
	КонецЕсли;
	//ОКЕЙ Морозов А.В. (СофтЛаб) Конец 2020-09-07 (#3775)
	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-07 (#3775)
	//МакетКомпоновки.ЗначенияПараметров.ОЦР.Значение = ПараметрыСеанса.бит_бк_ТекущийИнициатор;
	Если ЭтотОбъект.ТолстыйКлиент Тогда
		МакетКомпоновки.ЗначенияПараметров.ОЦР.Значение = ОтборОЦР;
	Иначе
		МакетКомпоновки.ЗначенияПараметров.ОЦР.Значение = ПараметрыСеанса.бит_бк_ТекущийИнициатор;
	КонецЕсли;
	//ОКЕЙ Морозов А.В. (СофтЛаб) Конец  2020-09-07 (#3775)
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	Результат = Новый ТаблицаЗначений;
	
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Результат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Если БылУстановленПривелегированныйРежим 
	   И ПривилегированныйРежим() 
	Тогда 
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат Результат.Количество() <> 0;
		
КонецФункции

//ОКЕЙ Морозов А.В. (СофтЛаб) Начало 2020-09-07 (#3775)
Функция ПроверитьОбязательныеОтборы(Знач ОтборСКД)
	
	пКДОЦР = Новый ПолеКомпоновкиДанных("ОЦР");
	Для Каждого ЭлОтбора Из ОтборСКД.Элементы Цикл
		Если ЭлОтбора.ЛевоеЗначение = пКДОЦР Тогда 
			Если НЕ (ЭлОтбора.Использование И ЗначениеЗаполнено(ЭлОтбора.ПравоеЗначение)) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Отсутствует обязательный отбор по ОЦР!'"));
				Возврат Справочники.бит_БК_Инициаторы.ПустаяСсылка();
			ИначеЕсли ЭлОтбора.Использование И ЗначениеЗаполнено(ЭлОтбора.ПравоеЗначение) Тогда
				Возврат ЭлОтбора.ПравоеЗначение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат Справочники.бит_БК_Инициаторы.ПустаяСсылка();
	
КонецФункции
//ОКЕЙ Морозов А.В. (СофтЛаб) Конец  2020-09-07 (#3775)

