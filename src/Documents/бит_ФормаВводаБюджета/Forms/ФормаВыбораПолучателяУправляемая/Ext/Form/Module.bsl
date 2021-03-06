
&НаКлиенте
Процедура Отмена(Команда)
	Отмеченные.Очистить();
	Закрыть(Отмеченные);
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(Отмеченные);
КонецПроцедуры

&НаСервере
Процедура ВыделитьИзбранныхВДинСписке()
	УО = ДинСписок.УсловноеОформление.Элементы;
	ЭлементУО = УО.Добавить();
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый  Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , ,Истина , , , ));
	ЭлементУсловия = ЭлементУО.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементУсловия.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Группа");
	ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементУсловия.ПравоеЗначение = 1;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВыборСделан=ложь;
	
	Список_=Параметры.Избранные;
	параметрыИзбранные=новый массив;
	Если типЗнч(Список_)=тип("СписокЗначений") тогда
		параметрыИзбранные=список_.ВыгрузитьЗначения();		
	КонецЕсли;
	
	ДинСписок.Параметры.УстановитьЗначениеПараметра("Избранные",параметрыИзбранные);
	
	ВыделитьИзбранныхВДинСписке();
КонецПроцедуры

&НаКлиенте
Процедура ВОтмеченные(Команда)		
	ВыбЗначение=Элементы.ДинСписок.ТекущиеДанные.Инициатор;
	Если Отмеченные.НайтиПоЗначению(ВыбЗначение)=неопределено тогда
		нов_=Отмеченные.Добавить();
		нов_.Значение=ВыбЗначение;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УбратьИзОтмеченных(Команда)
	удаляемое=Отмеченные.найтипозначению(Элементы.Отмеченные.ТекущиеДанные.Значение);
	Если не удаляемое=неопределено тогда
		Отмеченные.Удалить(удаляемое);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДинСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВОтмеченные(0);  
КонецПроцедуры

// БИТ НАГолубева 03.03.2016++
&НаКлиенте
Процедура УстановитьОтборВСпискеИнициаторов(фильтрЗначение)
	ДинСписок.Отбор.Элементы.Очистить();
	
	ЭлементУО = ДинСписок.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));		
	ЭлементУО.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Инициатор.Наименование");
	ЭлементУО.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
	ЭлементУО.ПравоеЗначение = фильтрЗначение;
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	УстановитьОтборВСпискеИнициаторов(Текст);
КонецПроцедуры
// БИТ НАГолубева 03.03.2016--