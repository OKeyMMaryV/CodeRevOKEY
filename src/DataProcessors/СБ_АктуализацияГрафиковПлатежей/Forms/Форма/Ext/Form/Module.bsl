﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Дата = ТекущаяДатаСеанса();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Документы

// Процедура-обработчик события "Выбор" табличной части "Документы"
// 	
&НаКлиенте
Процедура ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущийДокумент = Элементы.Документы.ТекущиеДанные.Документ;
	
	Форма = ПолучитьФорму("Документ.СБ_КорректировкаГрафиковПлатежейПоДополнительнымУсловиямПоДоговору.ФормаОбъекта", Новый Структура("Ключ", ТекущийДокумент));
	Форма.Открыть();
	Форма.Активизировать();
	
КонецПроцедуры // ДокументыВыбор()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Процедура-обработчик события "Нажатие" кнопки "Заполнить"
// 	командной панели табличной части "ДанныеАктуализации"
&НаКлиенте
Процедура КоманднаяПанельДанныеАктуализацииЗаполнить(Команда)
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		Сообщить("Не указана дата!");
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ПериметрКонсолидации) Тогда
		Сообщить("Не указан периметр консолидации!");
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТабличнуюЧасть_Вызов_Функции();
	
КонецПроцедуры // КоманднаяПанельДанныеАктуализацииЗаполнить()

// Процедура-обработчик события "Нажатие" кнопки "Выполнить"
// 	командной панели табличной части "ДанныеАктуализации"
&НаКлиенте
Процедура КоманднаяПанельДанныеАктуализацииВыполнить(Команда)
	
	ВыполнитьАктуализациюГрафиков_Вызов_Функции();
	
КонецПроцедуры // КоманднаяПанельДанныеАктуализацииВыполнить()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОПОВЕЩЕНИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ЗаполнитьТабличнуюЧасть_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.ЗаполнитьТабличнуюЧасть();
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Функция ВыполнитьАктуализациюГрафиков_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.ВыполнитьАктуализациюГрафиков();
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаКлиенте
Процедура ДанныеАктуализацииЗакрытьГрафикПриИзменении(Элемент)
	Элементы.ДанныеАктуализации.ТекущиеДанные.СкорректироватьГрафик = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеАктуализацииСкорректироватьГрафикПриИзменении(Элемент)
	Элементы.ДанныеАктуализации.ТекущиеДанные.ЗакрытьГрафик = Ложь;
КонецПроцедуры
