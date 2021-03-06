
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	фПолноеИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Истина);
	
	ЗаполнитьДополнительныеСписки();
	
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		Отчет[ИмяПараметра] = Параметры[ИмяПараметра];
	КонецЦикла;
	
	Отчет.НастройкаПериода 	= Параметры.НастройкаПериода;
		
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		ИмяПараметра = ЭлементСписка.Значение;
		бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет[ИмяПараметра], 
															ИмяПараметра);
	КонецЦикла;

КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
													
// Процедура - обработчик события "ПриИзменении" полей воода - простых параметров на форме.
// 
&НаКлиенте
Процедура ПростойПараметрПриИзменении(Элемент)
	
	ИмяПараметра = Элемент.Имя;
	бит_ОтчетыКлиент.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
															Отчет[ИмяПараметра], 
															ИмяПараметра);
															
КонецПроцедуры // ПростойПараметрПриИзменении()
														
// Процедура - обработчик события "ПриИзменении" 
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
							
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры // КомпоновщикНастроекПользовательскиеНастройкиПриИзменении()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды "КомандаЗавершитьРедактирование".
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет дополнительные списки.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура ЗаполнитьДополнительныеСписки()

	// Список имен параметров СКД, заполняемых пользователем через элементы формы.
	ИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Ложь); 
	Отчеты[ИмяОтчета].ЗаполнитьДополнительныеСписки(фСписокПараметровНаФорме);
		
КонецПроцедуры // ЗаполнитьДополнительныеСписки()

#КонецОбласти
