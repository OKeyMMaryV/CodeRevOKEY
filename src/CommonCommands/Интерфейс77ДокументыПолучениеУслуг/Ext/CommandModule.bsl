﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УсловияЗаполнения = Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.Услуги"));
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", УсловияЗаполнения);
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокументаУслуги", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры