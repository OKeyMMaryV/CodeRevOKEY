
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Отбор.Значение) Тогда
	
		ДоговорКонтрагента = Параметры.Отбор.Значение;
		ДанныеДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорКонтрагента, "Владелец, Организация");
		Контрагент     = ДанныеДоговора.Владелец;
		Организация    = ДанныеДоговора.Организация;
		
	Иначе
		
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		Контрагент         = Справочники.Контрагенты.ПустаяСсылка();
		Организация        = Справочники.Организации.ПустаяСсылка();
		
	КонецЕсли; 
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Контрагент", Контрагент, ВидСравненияКомпоновкиДанных.Равно, , Истина, 
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ДоговорКонтрагента", ДоговорКонтрагента, ВидСравненияКомпоновкиДанных.Равно, , Истина, 
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно, , Истина, 
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
			
КонецПроцедуры

#КонецОбласти
