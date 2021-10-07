﻿#Область ПрограммныйИнтерфейс

Функция ПолучитьКоэффициентЕдиницыИзмеренияВЕТИС(ЕдиницаИзмеренияВЕТИС, Номенклатура) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ЕдиницаИзмеренияВЕТИС", ЕдиницаИзмеренияВЕТИС);
	запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КоэффициентыЕдиницИзмеренияВЕТИС.КоэффициентЕдиницыВЕТИС КАК КоэффициентЕдиницыВЕТИС
	|ИЗ
	|	РегистрСведений.КоэффициентыЕдиницИзмеренияВЕТИС КАК КоэффициентыЕдиницИзмеренияВЕТИС
	|ГДЕ
	|	КоэффициентыЕдиницИзмеренияВЕТИС.Номенклатура = &Номенклатура
	|	И КоэффициентыЕдиницИзмеренияВЕТИС.ЕдиницаИзмеренияВЕТИС = &ЕдиницаИзмеренияВЕТИС";
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Возврат ?(ЗначениеЗаполнено(Результат.КоэффициентЕдиницыВЕТИС), Результат.КоэффициентЕдиницыВЕТИС, Неопределено);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции

// Возвращает ссылку на элемент справочника КлассификаторЕдиницИзмерения по единице измерения ВЕТИС.
//
Функция ПолучитьЕдиницуИзмерения(ЕдиницаИзмеренияВЕТИС) Экспорт

	Возврат ИнтеграцияВЕТИСБП.ПолучитьЕдиницуИзмерения(ЕдиницаИзмеренияВЕТИС);

КонецФункции

// Возвращает ссылку на элемент справочника Контрагенты по хозяйствующему субъекту и предприятию ВЕТИС.
//
Функция ПолучитьКонтрагента(ХозяйствующийСубъектВЕТИС, ПредприятиеВЕТИС = Неопределено) Экспорт

	Возврат ИнтеграцияВЕТИСБП.ПолучитьКонтрагента(ХозяйствующийСубъектВЕТИС, ПредприятиеВЕТИС);

КонецФункции

#КонецОбласти
