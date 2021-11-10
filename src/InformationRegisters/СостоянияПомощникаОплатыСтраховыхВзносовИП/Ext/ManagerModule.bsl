﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура СохранитьСостояниеПомощника(Данные) Экспорт
	
	Запись = СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, Данные);
	
	Запись.Записать(Истина);
	
КонецПроцедуры

Функция ПолучитьСостояниеПомощника(Организация) Экспорт
	
	Возврат Получить(Новый Структура("Организация", Организация));
	
КонецФункции

#КонецОбласти

#КонецЕсли