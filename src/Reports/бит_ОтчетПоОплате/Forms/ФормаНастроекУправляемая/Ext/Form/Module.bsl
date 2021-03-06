
////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// бит_ASubbotina Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет[ИмяПараметра], 
															ИмяПараметра);
	КонецЦикла;

КонецПроцедуры // ПриОткрытии()


////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ
                           
// бит_ASubbotina Процедура - обработчик команды "КомандаВыбратьПериодчерезФорму"
//
&НаКлиенте
Процедура КомандаНастроитьПериод(Команда)
	
	бит_РаботаСДиалогамиКлиент.НастроитьПериод(Отчет.Период, Отчет.НастройкаПериода);
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет.Период, 
															"Период");
			
КонецПроцедуры // КомандаНастроитьПериод()

// бит_ASubbotina Процедура - обработчик команды "КомандаЗавершитьРедактирование"
//
&НаКлиенте
Процедура КомандаЗавершитьРедактирование(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("НастройкаПериода", Отчет.НастройкаПериода);
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		СтруктураПараметров.Вставить(ИмяПараметра , Отчет[ИмяПараметра]);
	КонецЦикла;
	СтруктураПараметров.Вставить("ПользовательскиеНастройки" , Отчет.КомпоновщикНастроек.ПользовательскиеНастройки);
	
	// Оповещение формы отчета
	Оповестить("ИзмененыНастройки_" + фПолноеИмяОтчета, СтруктураПараметров);
	
	Закрыть();
	
КонецПроцедуры // КомандаЗавершитьРедактирование()


////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// бит_ASubbotina Процедура - обработчик события "ПриИзменении" поля ввода "ПериодДатаНачала".
//
&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет.Период.ДатаНачала, 
															"Период", 
															"ДатаНачала");
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, 
																				Отчет.Период.ДатаОкончания);
		
КонецПроцедуры // ПериодДатаНачалаПриИзменении()

// бит_ASubbotina Процедура - обработчик события "ПриИзменении" поля ввода "ПериодДатаОкончания".
//
&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет.Период.ДатаОкончания, 
															"Период", 
															"ДатаОкончания");
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, 
																				 Отчет.Период.ДатаОкончания);
		
КонецПроцедуры // ПериодДатаОкончанияПриИзменении()

// бит_ASubbotina Процедура - обработчик события "ПриИзменении" поля ввода "ПериодВариант".
//
&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет.Период.Вариант, 
															"Период", 
															"Вариант");
		
КонецПроцедуры // ПериодВариантПриИзменении()
														
// бит_ASubbotina Процедура - обработчик события "ПриИзменении" полей воода - простых параметров на форме.
//
&НаКлиенте
Процедура ПростойПараметрПриИзменении(Элемент)
	
	ИмяПараметра = Элемент.Имя;
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет[ИмяПараметра], 
															ИмяПараметра);
															
КонецПроцедуры // ПростойПараметрПриИзменении()

// бит_ASubbotina Процедура - обработчик события "ПриИзменении" 
// поля "КомпоновщикНастроекПользовательскиеНастройки".
//
&НаКлиенте
Процедура КомпоновщикНастроекПользовательскиеНастройкиПриИзменении(Элемент)
	
	Для каждого ИдЭлемента Из Элемент.ВыделенныеСтроки Цикл
		
		НастройкаКд  = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдЭлемента);
		Если ТипЗнч(НастройкаКд) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			
			ИмяПараметра = Строка(НастройкаКд.Параметр);
			
			Если фСписокПараметровНаФорме.НайтиПоЗначению(ИмяПараметра) <> Неопределено Тогда
				
				Отчет[ИмяПараметра] = НастройкаКд.Значение;
				
				Если ИмяПараметра = "Период" Тогда
			 		ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, Отчет.Период.ДатаОкончания);
				КонецЕсли;
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры // КомпоновщикНастроекПользовательскиеНастройкиПриИзменении()


////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// бит_ASubbotina Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.Отчеты.бит_ОтчетПоОплате;
	фПолноеИмяОтчета = МетаданныеОбъекта.ПолноеИмя();
	
	ЗаполнитьДополнительныеСписки();
	
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		Отчет[ИмяПараметра] = Параметры[ИмяПараметра];
	КонецЦикла;
	Отчет.НастройкаПериода 		 = Параметры.НастройкаПериода;
				
КонецПроцедуры // ПриСозданииНаСервере()


////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// бит_ASubbotina Процедура заполняет дополнительные списки
//
// Параметры:
//  Нет
//
&НаСервере
Процедура ЗаполнитьДополнительныеСписки()

	// Список имён параметров СКД, заполняемых пользователем через элементы формы
	фСписокПараметровНаФорме.Добавить("Период");

	
КонецПроцедуры // ЗаполнитьДополнительныеСписки()

