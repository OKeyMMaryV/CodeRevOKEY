
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Период");
	ПараметрДанных.Значение = КонецДня(Период);
	ПараметрДанных.Использование = ЗначениеЗаполнено(Период);

	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Организация");
	ПараметрДанных.Значение = Организация;
	ПараметрДанных.Использование = ЗначениеЗаполнено(Организация);
	
	стрЗаголовок = ?(ЗначениеЗаполнено(Организация), БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Организация) + Символы.ПС, "") + "Амортизация ОС на разных объектах" + ?(ЗначениеЗаполнено(Период), " на " + Формат(Период, "ДФ=dd.MM.yyyy"), "");
	
	КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("Title").Значение = стрЗаголовок;
КонецПроцедуры
