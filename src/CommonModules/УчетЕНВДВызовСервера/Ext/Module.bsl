﻿#Область ПрограммныйИнтерфейс

// Возвращает имя формы заявления
//
// Параметры:
//   ВидЗаявления - ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения - вид заявления
//
Функция ИмяФормыЗаявления(ВидЗаявления) Экспорт
	
	ИмяОтчета = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПолучитьИмяОтчетаПоВидуУведомления(ВидЗаявления);
	Если ПустаяСтрока(ИмяОтчета) Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяФормы = РегламентированнаяОтчетность.ПолучитьАктуальнуюФормуУведомления(ВидЗаявления);
	Если ПустаяСтрока(ИмяФормы) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СтрШаблон("Отчет.%1.Форма.%2", ИмяОтчета, ИмяФормы);
	
КонецФункции

#КонецОбласти